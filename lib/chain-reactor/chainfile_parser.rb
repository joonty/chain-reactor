module ChainReactor

  require 'reactor'

  # Error raised when there's a error parsing the chain file.
  #
  # This contains the original exception raised by eval().
  class ChainfileParserError < StandardError
    attr_reader :original
    def initialize(original)
      @original = original
      super(original.message.gsub(/\sfor #<ChainReactor.*>/,''))
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
    #
    # A ChainfileParserError is raised if the chain file has invalid syntax.
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

    # Set the address to bind to.
    def address(addr)
      @config.address = addr
    end

    # Set the port to listen on.
    def port(port)
      @config.port = port
    end

    # Set the pid file path.
    def pidfile(pidfile)
      @config.pid_file = pidfile
    end
    #
    # Set the log file path.
    def logfile(logfile)
      @config.log_file = logfile
    end

    # Set whether to run multithreaded.
    def multithreaded(multithreaded = true)
      @config.multithreaded = !!multithreaded
    end

  end
end
