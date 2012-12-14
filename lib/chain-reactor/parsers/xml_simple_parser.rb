module ChainReactor::Parsers
  # Parse the string as a JSON object.
  class XmlSimpleParser < Parser
    require 'xmlsimple'

    def do_parse(string)
      begin
        @log.debug { "Parsing XML string #{string.inspect}" }
        XmlSimple.xml_in(string)
      rescue StandardError => e
        raise ParseError, "Data from client is not a valid XML string: #{string}, #{e.class.name} error: #{e.message}, data: #{string}"
      end
    end
  end
end
