module ChainReactor

  # Exception used by the Client class, signifying incorrect connection
  # details for a client.
  class ClientError < StandardError
  end

  # Holds information about the connected client, and provides access to the
  # socket.
  #
  # The host, ip and port of the client are provided as attributes.
  class Client
    # Allow read access
    attr_reader :ip, :port

    # Create the Client with a TCPSocket. This socket holds connection
    # parameters and allows data transfer both ways.
    def initialize(socket)
      @socket = socket
      fam, @port, *addr = @socket.getpeername.unpack('nnC4')

      @ip = addr.join('.')
      puts "New connection from #{@ip}:#{@port}"
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
      puts "Closing connection to client #{@ip}"
      @socket.close
    end

  end

end
