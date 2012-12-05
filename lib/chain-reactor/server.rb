module ChainReactor

  require 'socket'
  require 'parser'
  require 'client'

  # Creates a server socket and listens for client connections on an infinite
  # loop. Each connecting client creates a new thread, allowing multiple
  # connections at the same time.
  class Server
    
    # Create a new <tt>TCPServer</tt> listening on the given port.
    def initialize
      @server = TCPServer.open(Conf.bind_address,Conf.port)
      puts "Starting the ChainReaction v#{VERSION} server"
      Thread.abort_on_exception = true
    end

    # Start the server listening on an infinite loop.
    #
    # When clients connect, a new thread is created. Keyboard interrupts are
    # caught and handled gracefully.
    def start
      begin
        loop do
          Thread.new(@server.accept) do |client_sock|
            begin
              client = Client.new(client_sock)
              handle_client(client)
            rescue ClientError => e
              puts e.message
              client.close
            rescue Reactions::ReactionError => e
              puts e.message
            rescue ParseError => e
              puts e.message
            end
          end
        end
      rescue Interrupt, SystemExit
        puts "Shutting down the ChainReaction server"
        raise SystemExit
      end
    end

    private

    # Handle a single client connection. First, the IP address  is checked to 
    # see whether it's allowed to connect. Then the server sends a welcome 
    # message so the client knows what it's connected to. Finally,
    # data is read from the client and turned into a command.
    def handle_client(client)
      conf = get_client_conf(client)
      puts "Connected to client #{client.ip}"
      client.say("ChainReactor v#{VERSION}")

      client_string = ''
      while l = client.read
        client_string += l
      end
      puts "Read from client: #{client_string}"

      client.close

      conf['parser'] ||= 'json'
      parser = Parser.get(conf['parser'],client)
      cause = parser.parse(client_string)

      Reactions::ReactionList.exec(conf['reaction'],cause)
    end

    # Try and get the configuration data for the given client. If the IP
    # address has not been allowed then a <tt>ClientError</tt> is thrown,
    # which closes the connection.
    def get_client_conf(client)
      ret_conf = nil
      Conf.clients.each do |conf|
        if conf['ip'] == client.ip
          ret_conf = conf
          break
        end
      end
      if not ret_conf
        raise ClientError, "Client with IP address #{client.ip} is not allowed"
      end
      ret_conf
    end

  end

end
