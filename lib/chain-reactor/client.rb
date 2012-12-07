require 'socket'
require 'json'

module ChainReactor
  # A client for connecting to a chain reactor server.
  class Client

    def initialize(server_addr,server_port)
      @socket = TCPSocket.new server_addr, server_port
      connect
    end

    # Send data to the server and close the connection.
    def send(data_hash)
      json_string = JSON.generate(data_hash)
      puts "Sending data: #{json_string}"
      @socket.puts json_string
      @socket.close
    end
    
    private
    # Connect and check the server response.
    def connect
      intro = @socket.gets
      unless intro.include? "ChainReactor"
        @socket.close
        raise "Invalid server response: #{intro}"
      end
    end

  end
end
