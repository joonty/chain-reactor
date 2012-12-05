
module ChainReactor

  # Exception for accessing config options that don't exist. Instead of
  # passing a full message, the key name is passed and the message is
  # formatted nicely.
  class ConfKeyError < StandardError
    # Create a new ConfigKeyError with the name of the key that was accessed.
    def initialize(key)
      super("Configuration option '#{key}' does not exist")
    end
  end

  # Holds configuration data parsed from the YAML file. Individual options
  # are accessed using the various methods provided, to give it some rigidity.
  #
  # This class is used statically, and there can only be one instance.
  class Conf
    # Load configuration data (as a hash).
    def self.load(conf_data)
      @@data = conf_data
    end

    # Get the port number.
    def self.port
      self.get("port")
    end

    # Get the IP/host name address for the server to bind to.
    def self.bind_address
      self.get("bind_address")
    end

    # Get the list of clients.
    def self.clients
      self.get("clients")
    end

    # Get a key from the configuration data.
    #
    # Raises a ConfigKeyError if the key doesn't exist.
    def self.get(key)
      if @@data.has_key?(key)
        @@data[key]
      else
        raise ConfKeyError, key
      end
    end

  end

end
