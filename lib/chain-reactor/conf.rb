module ChainReactor
  # Raised when trying to access a non-existent configuration option.
  class ConfError < StandardError
  end

  require 'main'

  # Configuration object that combines default values and command line options.
  #
  # The command line parameters are provided through the gem 'main', and these
  # take precedent over options set through the chain file.
  class Conf

    # Create a new Conf object with the parameters from Main.
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

    # Set the default bind IP address.
    def address=(address)
      set_default :address, address
    end

    # Get the IP address to bind to.
    def address
      get_value :address
    end

    # Set the log file location.
    def log_file=(log_file)
      set_default :logfile, log_file
    end

    # Get the log file location.
    def log_file
      get_value :logfile
    end
    
    # Set the pid file location.
    def pid_file=(pid_file)
      set_default :pidfile, pid_file
    end

    # Get the pid file location.
    def pid_file
      get_value :pidfile
    end

    # Set the default port number.
    def port=(port)
      set_default :port, port
    end

    # Get the port number.
    def port
      get_value :port
    end

    # Set the whether to run multithreaded by default.
    def multithreaded=(multithreaded)
      set_default :multithreaded, multithreaded
    end

    # Whether the server should open each client connection in a new thread.
    def multithreaded
      get_value :multithreaded
    end

    # Set the default verbosity.
    def verbosity=(verbosity)
      set_default :verbosity, verbosity
    end

    # How verbose the program should be.
    def verbosity
      get_value :verbosity
    end

    # Set whether to run on top (instead of daemonizing).
    def on_top=(on_top)
      set_default :ontop, on_top
    end

    # Whether to run on top (instead of daemonizing).
    def on_top
      get_value :ontop
    end

    # Alias for on_top().
    alias :on_top? :on_top
    # Alias for multithreaded().
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
      begin
        param = @params.fetch(key)
        if param.given?
          param.value
        elsif @defaults.has_key? key
          @defaults[key]
        else
          param.value
        end
      rescue ::Main::Parameter::NoneSuch
        raise ConfError, "Missing configuration parameter '#{key}'"
      end
    end
  end
end
