module ChainReactor
  class Controller
    require 'chainfile_parser'
    require 'server'
    require 'dante'

    def initialize(config,log)
      @config = config
      @log = log
      # log to STDOUT/ERR while parsing the chain file, only daemonize when complete.
      @reactor = ChainfileParser.new(@config.chainfile,@config,@log).parse

    end

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

    def stop
      ARGV.replace []
      Dante::Runner.new('chain-reactor').execute(:kill => true, 
                                                 :pid_path => @config.pid_file)
    end

    protected

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
