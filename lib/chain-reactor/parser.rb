module ChainReactor

  # Error raised if there's an error parsing a string.
  class ParseError < StandardError
  end
  
  class RequiredKeyError < StandardError
  end

  # Used to parse strings using a method defined by child classes.
  class ParserFactory
    # Class method for retrieving a new Parser object depending on the type
    # variable.
    def self.get_parser(type,logger)
      class_name = type.to_s.capitalize
      if class_name.include? "_"
        class_name = class_namesplit('_').map{|e| e.capitalize}.join
      end
      parser_class_name = class_name + 'Parser'
      logger.debug { "Creating parser: #{parser_class_name}" }
      parser_class = ChainReactor::Parsers.const_get parser_class_name
      parser_class.new(logger)
    end
  end

  module Parsers
    class Parser
      def initialize(logger)
        @log = logger
      end

      def parse(string,required_keys,keys_to_sym)
        data = do_parse(string.strip)
        if keys_to_sym
          @log.debug { "Converting data keys #{data.keys} to symbols" }
          data = Hash[data.map { |k,v| [k.to_sym, v] }]
        end
        required_keys.each do |key|
          data.has_key? key or raise RequiredKeyError, "Required key #{key} is missing from data #{data}"
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

    # Parse the string as a JSON object.
    class JsonParser < Parser
      require 'json'

      def do_parse(string)
        begin
          @log.debug { "Parsing JSON string #{data.inspect}" }
          JSON.parse(string)
        rescue JSON::ParserError
          raise ParseError, "Data from client is not a valid JSON: #{string}"
        end
      end
    end
  end

end
