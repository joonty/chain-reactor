module ChainReactor::Parsers

  # Error raised if there's an error parsing a string.
  class ParseError < StandardError
  end
  
  # Error raised if a required key is missing
  class RequiredKeyError < StandardError
  end

  class Parser
    def initialize(logger)
      @log = logger
    end

    # Parse the string sent by the client.
    #
    # Calls the do_parse() method which is defined by a subclass.
    #
    # Required keys can be passed as an array, and a RequiredKeyError
    # is raised if any of those keys don't exist in the returned value
    # from do_parse().
    #
    # keys_to_sym converts all string keys to symbol keys, and is true
    # by default. 
    def parse(string,required_keys,keys_to_sym)
      data = do_parse(string.strip)
      if keys_to_sym
        @log.debug { "Converting data keys #{data.keys} to symbols" }
        data = Hash[data.map { |k,v| [k.to_sym, v] }]
      end
      required_keys.each do |key|
        data.has_key? key or raise RequiredKeyError, "Required key '#{key}' is missing from data #{data}"
      end
      data
    end

    # Parse the string, using an implmentation defined by child classes. A
    # <tt>Cause</tt> object is returned, loaded with the name, type and 
    # client.
    #
    # Should return a hash.
    def do_parse(string)
      raise 'This method should implement a string to hash parser'
    end
  end
end

