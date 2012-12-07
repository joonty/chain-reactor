require 'socket'
require 'json'

module ChainReactor
  # A client for connecting to a chain reactor server.
  class Clientclass

    def initialize(server_addr,server_port)
      @socket = TCPSocket.new server_addr, server_port
      connect
    end

    # Send data to the server and close the connection.
    def send(data_hash)
      @socket.puts JSON.generate(data_hash)
      @socket.close
    end
    
    private
    # Connect and check the server response.
    def connect
      intro = ''
      while l = @socket.gets
        intro += l
      end
      if intro !=~ /ChainReactor/
        @socket.close
        raise "Invalid server response: #{intro}"
      end
    end

  end
end
