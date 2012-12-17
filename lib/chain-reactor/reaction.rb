module ChainReactor

  # Raised if there's an error running a reaction.
  #
  # This is a simple wrapper around the originally raised exception.
  class ReactionError < StandardError
    attr_accessor :original_exception
    def initialize(original_exception)
      @original_exception = original_exception
      super(original_exception.message)
    end
  end

  # Represents a single reaction block, defined in the chain file with the 'react_to' method. 
  class Reaction

    require 'parser_factory'

    # The previous return value from this reaction, if executed before.
    attr_accessor :previous_result
    # The previous data set sent to this reaction, if executed before.
    attr_accessor :previous_data
    # Options used by this reaction.
    attr_accessor :options

    # Create a new reaction, with the options and code block to run.
    def initialize(options = {},block,logger)
      @options = { :parser => :json, :required_keys => [], :keys_to_sym => true }.merge(options)
      @block = block
      @log = logger
      @log.debug { "Created reaction with options: #{options}" }
    end

    # Executes the block of code after parsing the data string.
    def execute(data_string)
      parser = ParserFactory.get_parser(@options[:parser],@log)
      data = parser.parse(data_string,@options[:required_keys],@options[:keys_to_sym])
      begin
        @previous_result = @block.call(data)
        @previous_data = data
      rescue StandardError => e
        raise ReactionError.new(e)
      end
    end

  end
end
