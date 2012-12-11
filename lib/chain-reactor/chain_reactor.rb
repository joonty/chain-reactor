module ChainReactor

  lib_dir = File.dirname(__FILE__)
  $:.unshift lib_dir

  require "version"

  require 'rubygems'
  require 'main'
  require 'log4r'

  include Log4r

  Main do

    mode :start do
      description 'Start the chain reactor server'

      input :chainfile do
        description 'A valid chainfile - run with the template argument to create a template'
      end

      option :multithreaded do
        cast :bool
        defaults false
        description 'Whether to allow concurrent connections in separate threads'
      end

      option :log_file do
        argument :required
        description 'Log file to write messages to'
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

        Conf.instance.set_cli_params(params)

        log = Logger.new 'chain-reactor'
        log.level = ChainReactor.const_get(params[:debug].value.upcase)

        outputter = Outputter.stdout
        outputter.formatter = PatternFormatter.new(:pattern => "[%l] %d :: %m")
        log.outputters << outputter

        Dante::Runner.new('chain-reactor').execute(:daemonize => true, :pid_path => '/home/jon/chain-reactor.pid') do
          puts "hello"
          loop do
            sleep 10
          end
          begin
            log = Logger['chain-reactor']

            config = Conf.instance
            reactor = ChainfileParser.new(config.chainfile,log).parse
            server = Server.new(config.address,config.port,reactor,log)
            server.start(config.multithreaded?)
            puts "Ending, like a boss"
          rescue Exception => e
            puts "Caught exception"
            puts e.message
          end
        end
      end
    end

    mode :stop do
      description 'Stop a running chain reactor server'
      
      def run
        require 'conf'
        require 'dante'
        Dante::Runner.new('chain-reactor').execute(:kill => true, :pid_path => '/home/jon/chain-reactor.pid')

      end

    end
  end

end
