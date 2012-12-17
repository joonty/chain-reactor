module ChainReactor

  # Exception used by the ClientConnection class, signifying incorrect connection
  # details for a client.
  class ClientConnectionError < StandardError
  end

  # Holds information about the connected client, and provides access to the
  # socket.
  #
  # The host, ip and port of the client are provided as attributes.
  class ClientConnection

    # Client's IP address.
    attr_reader :ip
    # Client's port.
    attr_reader :port

    # Create the ClientConnection with a TCPSocket. This socket holds connection
    # parameters and allows data transfer both ways.
    def initialize(socket,logger)
      @socket = socket
      fam, @port, *addr = @socket.getpeername.unpack('nnC4')

      @ip = addr.join('.')
      @log = logger
      @log.info { "New connection from #{@ip}:#{@port}" }
    end

    # Write a string to the client socket, using <tt>TCPSocket.puts</tt>.
    def say(string)
      @socket.puts string
    end

    # Read from the client socket, using <tt>TCPSocket.gets</tt>.
    def read
      @socket.gets
    end

    # Close the socket connection, using <tt>TCPSocket.close</tt>.
    def close
      @log.info { "Closing connection to client #{@ip}" }
      @socket.close
    end

  end

end
