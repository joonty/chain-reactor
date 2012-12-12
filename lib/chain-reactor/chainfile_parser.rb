module ChainReactor

  require 'reactor'

  class ChainfileParserError < StandardError
    attr_reader :original
    def initialize(original)
      @original = original
      super(original.message)
    end
  end

  # Parse the chain file and register reaction code blocks and network addresses.
  class ChainfileParser

    # Set up a parser with a File object representing the chain file.
    def initialize(chainfile,config,logger)
      @file = chainfile
      @config = config
      @reactions = 0
      @reactor = Reactor.new(logger)
      @log = logger
    end

    # Parse the chain file and return a reactor object.
    def parse
      begin
        eval @file.read
      rescue Exception => e
        raise ChainfileParserError, e
      end

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

    def address(addr)
      @config.address = addr
    end

    def port(port)
      @config.port = port
    end

    def pidfile(pidfile)
      @config.pidfile = pidfile
    end

    def logfile(logfile)
      @config.logfile = logfile
    end

    def multithreaded(multithreaded)
      @config.multithreaded = !!multithreaded
    end

  end
end
