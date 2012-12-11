module ChainReactor

  require 'reactor'

  # Parse the chain file and register reaction code blocks and network addresses.
  class ChainfileParser

    # Set up a parser with a File object representing the chain file.
    def initialize(chainfile,logger)
      @file = chainfile
      @reactions = 0
      @reactor = Reactor.new(logger)
      @log = logger
    end

    # Parse the chain file and return a reactor object.
    def parse
      eval @file.read

      if @reactions.zero?
        @log.error { "No reactions registered, no reason to continue" }
        raise 'No reactions registered, no reason to continue'
      else
        @log.info { "Registered #{@reactions} reactions in the chain file" }
      end

      @reactor
    end

    # Register a reaction block, with IP addresses, arguments and a code block
    def react_to(addresses,args = {},&block)
      addresses = [*addresses]
      @reactions += 1
      @reactor.add(addresses,args,block)
    end
  end
end
