module ChainReactor

  require 'socket'
  require 'parsers/parser'
  require 'client_connection'

  # Creates a server socket and listens for client connections on an infinite
  # loop. Each connecting client creates a new thread, allowing multiple
  # connections at the same time.
  class Server
    
    # Create a new <tt>TCPServer</tt> listening on the given port.
    def initialize(address,port,reactor,logger)
      @server = TCPServer.open(address,port)
      @reactor = reactor
      @log = logger
      @log.info { "Started ChainReactor v#{VERSION} server on #{address}:#{port.to_s}" }
    end

    # Start the server listening on an infinite loop.
    #
    # When clients connect, a new thread is created. Keyboard interrupts are
    # caught and handled gracefully.
    def start(multithreaded)
      if multithreaded
        Thread.abort_on_exception = true
        @log.info "Accepting concurrent connections with new threads"
      end
      begin
        loop do
          if multithreaded
            Thread.new(@server.accept) do |client_sock|
              handle_sock(client_sock)
            end
          else
            handle_sock(@server.accept)
          end
        end
      rescue Interrupt, SystemExit => e
        @server.close
        @log.info { "Shutting down the ChainReactor server" }
        raise e
      rescue Exception => e
        @server.close
        raise e
      end
    end

    private

    def handle_sock(client_sock)
      begin
        client = ClientConnection.new(client_sock,@log)
        handle_client(client)
      rescue ClientConnectionError => e
        @log.error { "Client error: #{e.message}" }
        client.close
      end
    end

    # Handle a single client connection. First, the IP address  is checked to 
    # see whether it's allowed to connect. Then the server sends a welcome 
    # message so the client knows what it's connected to. Finally,
    # data is read from the client and turned into a command.
    def handle_client(client)
      unless @reactor.address_allowed? client.ip
        client.close
        @log.warn { "Terminated connection from unauthorized client #{client.ip}" }
        return
      end

      client.say("ChainReactor v#{VERSION}")

      client_string = ''
      while l = client.read
        client_string += l
      end

      @log.debug { "Read from client #{client.ip}: #{client_string}" }
      @log.info { "Finished reading from client #{client.ip}, closing connection" }

      client.close

      @reactor.react(client.ip,client_string)

    end
  end

end
