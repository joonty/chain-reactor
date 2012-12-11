
module ChainReactor
  lib_dir = File.dirname(__FILE__)
  $:.unshift lib_dir

  require "version"

  require 'rubygems'
  require 'daemons'
  require 'main'
  require 'log4r'

  include Log4r

  Main do
    input :data do
      optional
    end

    option :address do
      argument_required
      required
      cast :string
      description 'Chain reactor server address'
    end

    option :port do
      argument_required
      required
      cast :int
      description 'Chain reactor server port number'
    end

    def run
      require 'client'

      client = Client.new params[:address].value, params[:port].value
      data_input = params[:data].value

      if data_input
        client.send_raw(data_input.gets)
      else
        STDOUT.sync = true
        hash_to_send = {}
        puts "No data supplied, what do you want to send? (Leave key blank to end)"
        incr = 1

        loop do
          print "Key ##{incr}: "
          key = STDIN.gets.chomp

          if key == ""
            break
          end

          print "Value ##{incr}: "
          value = STDIN.gets.chomp

          hash_to_send[key] = value
        end
  
        client.send(hash_to_send)
        client.close()
      end
    end
  end
end
