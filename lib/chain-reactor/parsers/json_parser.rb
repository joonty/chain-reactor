module ChainReactor::Parsers

  # Parse the string as a JSON object.
  class JsonParser < Parser
    require 'json'

    # Parse a JSON string, returning the result as a hash.
    #
    # Raises a ParseError on failure.
    def do_parse(string)
      begin
        @log.debug { "Parsing JSON string #{string.inspect}" }
        JSON.parse(string)
      rescue JSON::ParserError => e
        raise ParseError, "Data from client is not a valid JSON: #{string}, error: #{e.message}, data: #{string}"
      end
    end
  end

end
