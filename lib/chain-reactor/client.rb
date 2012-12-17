require 'socket'
require 'json'

module ChainReactor

  # An error raised if there are communication problems with the server.
  class ClientError < StandardError
  end

  # A client for connecting to a chain reactor server.
  class Client
    # The version of the chain reactor server.
    attr_reader :version

    def initialize(server_addr,server_port)
      begin
        @socket = TCPSocket.new(server_addr, server_port)
      rescue Errno::ECONNREFUSED
        raise ClientError, "Failed to connect to Chain Reactor server on #{server_addr}:#{server_port}"
      end
      connect
    end

    # Send hash data to the server as a JSON
    def send_as_json(data_hash)
      if data_hash.length > 0
        json_string = JSON.generate(data_hash)
        send(json_string)
      else
        raise ClientError, 'Cannot send empty data to chain reactor server'
      end
    end
    
    # Send a data string to the server
    def send(data_string)
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
