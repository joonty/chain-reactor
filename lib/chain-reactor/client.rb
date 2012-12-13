require 'socket'
require 'json'

module ChainReactor

  class ClientError < StandardError
  end

  # A client for connecting to a chain reactor server.
  class Client
    attr_reader :version

    def initialize(server_addr,server_port)
      @socket = TCPSocket.new server_addr, server_port
      connect
    end

    # Send hash data to the server
    def send(data_hash)
      if data_hash.length > 0
        json_string = JSON.generate(data_hash)
        puts "Sending data: #{json_string}"
        @socket.puts json_string
      else
        raise ClientError, 'Cannot send empty data to chain reactor server'
      end
    end
    
    # Send raw data to the server
    def send_raw(data_string)
      data_string.strip!
      if data_string.length > 0
        puts "Sending data: #{data_string}"
        @socket.puts data_string
      else
        raise ClientError, 'Cannot send empty data to chain reactor server'
      end
    end

    # Close the client socket.
    def close
      @socket.close
    end
    
    private
    # Connect and check the server response.
    def connect
      intro = @socket.gets
      matches = /^ChainReactor v([\d.]+)/.match(intro)
      if matches
        @version = matches[1]
      else
        @socket.close
        raise ClientError, "Invalid server response: #{intro}"
      end
    end

  end
end
