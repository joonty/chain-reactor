module ChainReactor

  require 'parsers/parser'
  require 'parsers/json_parser'

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
end
