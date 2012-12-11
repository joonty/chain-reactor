require 'singleton'

module ChainReactor
  class ConfError < StandardError
  end

  class Conf
    include Singleton

    def initialize
      @params = {}
      @defaults = {}
    end

    def destroy
      @params = {}
      @defaults = {}
    end

    def set_cli_params(params)
      @params = params
    end

    # Set the default bind IP address
    def address=(address)
      set_default :address, address
    end

    # Get the IP address to bind to
    def address
      get_value :address
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

    # Question mark aliases
    alias :silent? :silent
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
      if @params.has_key? key 
        if @params[key].given?
          @params[key].value
        elsif @defaults.has_key? key
          @defaults[key]
        else
          @params[key].value
        end
      elsif @defaults.has_key? key
        @defaults[key]
      else
        raise ConfError, "Missing configuration value '#{key}'"
      end
    end
  end
end
