
module ChainReactor
  lib_dir = File.dirname(__FILE__)
  $:.unshift lib_dir

  require 'version'
  require 'rubygems'
  require 'main'

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
      defaults 1987
    end

    # Connect to a running chain reactor server and send data.
    def run
      require 'client'

      begin
        client = Client.new params[:address].value, params[:port].value
        puts "Connected to Chain Reactor server, version #{client.version}"
        data_input = params[:data].value

        if data_input
          client.send(data_input.gets.strip)
        else
          client.send_as_json(get_hash_from_stdin)
          client.close()
        end
        exit_status exit_success
      rescue ClientError => e
        STDERR.puts e.message
        exit_status exit_failure
      rescue SystemExit, Interrupt
        STDERR.puts "Caught exit signal" 
        exit_status exit_failure
      rescue Exception => e
        STDERR.puts "An error occured {#{e.class.name}}: #{e.message}" 
        exit_status exit_failure
      end
    end

    # Ask the user for key value pairs, and return as a hash.
    def get_hash_from_stdin
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
        incr += 1
      end
      hash_to_send
    end
  end

end
