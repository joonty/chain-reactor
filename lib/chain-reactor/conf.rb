module ChainReactor
  class ConfError < StandardError
  end

  require 'main'

  class Conf
    def initialize(cli_params)
      @params = cli_params
      @defaults = {}
    end

    # Get the chainfile, as a File object.
    #
    # This is the exception - it has to come as a CLI parameter.
    def chainfile
      @params[:chainfile].value
    end

    # Set the default bind IP address
    def address=(address)
      set_default :address, address
    end

    # Get the IP address to bind to
    def address
      get_value :address
    end

    # Set the log file location
    def log_file=(log_file)
      set_default :logfile, log_file
    end

    # Get the IP log_file to bind to
    def log_file
      get_value :logfile
    end
    
    # Set the pid file location
    def pid_file=(pid_file)
      set_default :pidfile, pid_file
    end

    # Get the IP pid_file to bind to
    def pid_file
      get_value :pidfile
    end

    # Set the default port number
    def port=(port)
      set_default :port, port
    end

    # Get the port number
    def port
      get_value :port
    end

    # Set the default multithreaded option
    def multithreaded=(multithreaded)
      set_default :multithreaded, multithreaded
    end

    # Get the multithreaded option
    def multithreaded
      get_value :multithreaded
    end

    # Set the default verbosity option
    def verbosity=(verbosity)
      set_default :verbosity, verbosity
    end

    # Get the verbosity option
    def verbosity
      get_value :verbosity
    end

    # Set the default silent option
    def silent=(silent)
      set_default :silent, silent
    end

    # Get the silent option
    def silent
      get_value :silent
    end

    # Set the default on_top option
    def on_top=(on_top)
      set_default :ontop, on_top
    end

    # Get the on_top option
    def on_top
      get_value :ontop
    end

    # Question mark aliases
    alias :silent? :silent
    alias :on_top? :on_top
    alias :multithreaded? :multithreaded

    private

    # Set the default value for a key.
    #
    # This value is used only if the equivalent command line
    # parameter is not given.
    def set_default(key,value)
      if @defaults.nil?
        @defaults = {}
      end
      @defaults[key] = value
    end

    # Get the value for a key.
    #
    # The command line parameters take precedence if given explicitly,
    # followed by values set on the Conf object. Finally, default command
    # line values are used.
    #
    # A ConfError exception is thrown if the key is unknown.
    def get_value(key)
      if @params.fetch(key,nil).nil?
        raise ConfError, "Missing configuration value '#{key}'"
      else
        if @params[key].given?
          @params[key].value
        elsif @defaults.has_key? key
          @defaults[key]
        else
          @params[key].value
        end
      end
    end
  end
end
