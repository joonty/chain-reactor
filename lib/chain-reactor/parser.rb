module ChainReactor

  require 'json'
  require 'cause'

  # Error raised if there's an error parsing a string.
  class ParseError < StandardError
  end

  # Used to parse strings using a method defined by child classes.
  class Parser

    # Create a new parser, with a <tt>Client</tt> object.
    def initialize(client)
      @client = client
    end

    # Class method for retrieving a new Parser object depending on the type
    # variable.
    def self.get(type,client)
      case type
      when 'json'
        JsonParser.new(client)
      else
        raise ParseError, "Unknown parse type #{type}"
      end
    end

    # Parse the string, using an implmentation defined by child classes. A
    # <tt>Cause</tt> object is returned, loaded with the name, type and 
    # client.
    def parse(string)
      raise 'This method should implement a string parser'
    end
  end

  # Parse the string as a JSON object.
  class JsonParser < Parser
    def parse(string)
      begin
        data = JSON.parse(string)
        data.has_key?('name') or raise ParseError, 
                                'Data from client is missing key "name"'
        data.has_key?('type') or raise ParseError, 
                                'Data from client is missing key "type"'
        Cause.new(@client,data['type'],data['name'])
      rescue JSON::ParserError
        raise ParseError, "Data from client is not a valid JSON: #{string}"
      end
    end
  end

end
