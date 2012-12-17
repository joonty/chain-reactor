module ChainReactor
  
  # The Controller manages starting and stopping of the server, and daemonizing.
  class Controller

    require 'chainfile_parser'
    require 'server'
    require 'dante'

    # Parse the chain file with a ChainfileParser object.
    def initialize(config,log)
      @config = config
      @log = log
      # log to STDOUT/ERR while parsing the chain file, only daemonize when complete.
      @reactor = ChainfileParser.new(@config.chainfile,@config,@log).parse

    end

    # Start the server, as a daemon or on top if --ontop is supplied as a CLI arg.
    #
    # Uses dante as the daemonizer.
    def start
      # Change output format for logging to file if daemonizing
      unless @config.on_top?
        @log.outputters.first.formatter = ChainReactor::PatternFormatter.new(:pattern => "[%l] %d :: %m")
        @log.info { "Starting daemon, PID file => #{@config.pid_file}" }
      end

      # Dante picks up ARGV, so remove it
      ARGV.replace []
      server = Server.new(@config.address,@config.port,@reactor,@log)

      Dante::Runner.new('chain-reactor').execute(daemon_opts) do
        server.start(@config.multithreaded?)
      end
    end

    # Stop a daemonized process via the PID file specified in the options.
    def stop
      ARGV.replace []
      Dante::Runner.new('chain-reactor').execute(:kill => true, 
                                                 :pid_path => @config.pid_file)
    end

    protected

      # Get a hash of the options passed to the daemonizer, dante.
      def daemon_opts
        { 
          :daemonize => !@config.on_top, 
          :pid_path => @config.pid_file, 
          :log_path => @config.log_file,
          :debug => true
        }
      end
  end
end
