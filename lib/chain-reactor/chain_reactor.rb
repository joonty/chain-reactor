module ChainReactor

  lib_dir = File.dirname(__FILE__)
  $:.unshift lib_dir

  require "version"

  require 'rubygems'
  require 'main'
  require 'log4r'

  include Log4r

  Main do
    option :pidfile do
      argument :required
      description 'Pid file for the daemonized process'
      defaults Dir.pwd+'/chain-reactor.pid'
    end

    mode :start do
      description 'Start the chain reactor server'

      input :chainfile do
        description 'A valid chainfile - run with the template argument to create a template'
      end

      option :multithreaded do
        cast :bool
        defaults false
        description 'Start each new connection in a separate thread'
      end

      option :ontop do
        cast :bool
        defaults false
        description 'Keep the process on top instead of daemonizing'
      end

      option :logfile do
        argument :required
        description 'Log file to write messages to'
        defaults Dir.pwd+'/chain-reactor.log'
      end

      option :silent do
        cast :bool
        defaults false
        description 'Whether to suppress all messages to stdout'
      end

      option :debug do
        log_levels = %w(debug info warn error fatal)
        argument :required
        validate { |str| log_levels.include? str }
        synopsis '--debug=('+log_levels.join('|')+')  (0 ~> debug=info)'
        defaults 'info'
        description 'Type of messages to send to output'
      end

      option :address do
        argument :required
        defaults '127.0.0.1'
        description 'IP address to bind to'
      end
        
      option :port do
        argument :required
        defaults 20000
        description 'Port number to bind to'
      end

      def run
        require 'dante'
        require 'conf'
        require 'chainfile_parser'

        config = Conf.new(params)
        config.on_top?

        log = Logger.new 'chain-reactor'
        log.level = ChainReactor.const_get(params[:debug].value.upcase)

        outputter = Outputter.stdout
        outputter.formatter = PatternFormatter.new(:pattern => "[%l]\t%m")
        log.outputters << outputter

        # Log to STDOUT/ERR while parsing the chain file, only daemonize when complete.
        reactor = ChainfileParser.new(config.chainfile,log).parse

        unless config.on_top
          log.info { "Starting daemon, PID file => #{config.pid_file}" }
        end
        log.info { "Starting daemon, PID file => #{config.pid_file}" }
        # Change output format for logging to file
        outputter.formatter = PatternFormatter.new(:pattern => "[%l] %d :: %m")

        ARGV.replace []

        Dante::Runner.new('chain-reactor').execute(:daemonize => !config.on_top, 
                                                   :pid_path => config.pid_file, 
                                                   :log_path => config.log_file) do

          require 'server'
          begin
            server = Server.new(config.address,config.port,reactor,log)
            server.start(config.multithreaded?)
          rescue SystemExit
            exit_status exit_success
          rescue Exception => e
            log.error { "An error occured: #{e}" }
            exit_status exit_failure
          end
        end
      end
    end

    mode :stop do
      description 'Stop a running chain reactor server'
      
      def run
        require 'conf'
        require 'dante'
        puts "Attempting to stop chain reactor server with pid file: #{params[:pidfile].value}"
        failed = !Dante::Runner.new('chain-reactor').execute(:kill => true, :pid_path => params[:pidfile].value)
        exit_status exit_failure if failed
      end

    end
  end

end
