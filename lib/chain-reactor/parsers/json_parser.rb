module ChainReactor::Parsers
  # Parse the string as a JSON object.
  class JsonParser < Parser
    require 'json'

    def do_parse(string)
      begin
        @log.debug { "Parsing JSON string #{string.inspect}" }
        JSON.parse(string)
      rescue JSON::ParserError
        raise ParseError, "Data from client is not a valid JSON: #{string}"
      end
    end
  end
end
