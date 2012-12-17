module ChainReactor

  lib_dir = File.dirname(__FILE__)
  $:.unshift lib_dir

  require 'version'
  require 'rubygems'
  require 'main'
  require 'create_log'
  require 'conf'

  # Set up command line options and usage with the main gem.
  Main do
    examples 'chain-reactor start chainfile.rb ', 
             'chain-reactor stop chainfile.rb',
             'chain-reactor template'

    description 'Chain reactor is a server that responds to network events and runs ruby code. Run with the `start\' mode and \'--help\' to see options, or use the `template\' mode to create an example chainfile.'

    # Show the command line options if run without a mode.
    def run
      help!
    end

    # Start the server, as a daemon or on top.
    mode :start do

      description 'Start the chain reactor server, as a daemon or (optionally) on top. Daemonizing starts a background process, creates a pid file and a log file.'

      examples 'chain-reactor start chainfile.rb ', 
               'chain-reactor start chainfile.rb --ontop',
               'chain-reactor start chainfile.rb --pidfile /path/to/pidfile.pid'

      input :chainfile do
        description 'A valid chainfile - run with the template mode to create an example'
        error do |e| 
          STDERR.puts "chain-reactor: A valid chainfile must be supplied - run with the 'template' mode to generate an example"
        end
      end

      option :debug do
        log_levels = %w(debug info warn error fatal)
        argument :required
        validate { |str| log_levels.include? str }
        synopsis '--debug=('+log_levels.join('|')+')  (0 ~> debug=info)'
        defaults 'info'
        description 'Type of messages to send to output'
      end

      option :pidfile do
        argument :required
        description 'Pid file for the daemonized process'
        defaults Dir.pwd+'/chain-reactor.pid'
      end

      option :multithreaded do
        cast :bool
        defaults false
        description 'Start each new connection in a separate thread'
      end

      option :ontop do
        cast :bool
        defaults false
        description 'Keep the process on top instead of daemonizing'
      end

      option :logfile do
        argument :required
        description 'Log file to write messages to'
        defaults Dir.pwd+'/chain-reactor.log'
      end

      option :address do
        argument :required
        defaults '127.0.0.1'
        description 'IP address to bind to'
      end

      option :port do
        argument :required
        defaults 20000
        description 'Port number to bind to'
      end

      def run
        require 'controller'

        conf = Conf.new(params)
        log = ChainReactor.create_logger(params[:debug].value)

        begin
          Controller.new(conf,log).start
        rescue Interrupt, SystemExit
          exit_status exit_success
        rescue ChainfileParserError => e
          log.fatal { "Failed to parse chainfile {#{e.original.class.name}}: #{e.message}" }
          exit_status exit_failure
        rescue Exception => e
          log.fatal { "Unexpected exception {#{e.class.name}}: #{e.message}" }
          log.debug { $!.backtrace.join("\n\t") }
          exit_status exit_failure
        end
      end
    end

    mode :stop do
      description 'Stop a running chain reactor server daemon. Specify the path to the pid file to stop a specific chain reactor instance.'

      input :chainfile do
        description 'A valid chainfile - run with the template argument to create a template'
        error do |e| 
          STDERR.puts "chain-reactor: A valid chainfile must be supplied - run with the 'template' mode to generate an example"
        end
      end

      option :debug do
        log_levels = %w(debug info warn error fatal)
        argument :required
        validate { |str| log_levels.include? str }
        synopsis '--debug=('+log_levels.join('|')+')  (0 ~> debug=info)'
        defaults 'info'
        description 'Type of messages to send to output'
      end

      option :pidfile do
        argument :required
        description 'Pid file for the daemonized process'
        defaults Dir.pwd+'/chain-reactor.pid'
      end

      def run
        require 'controller'

        log = ChainReactor.create_empty_logger(params[:debug].value)
        conf = Conf.new(params)

        puts "Attempting to stop chain reactor server with pid file: #{conf.pid_file}"
        c = Controller.new(conf,log)
        failed = c.stop

        exit_status(exit_failure) if failed
      end

    end

    mode 'template' do
      description 'Create a template chainfile, to see examples of configuration options and reaction syntax.'

      examples 'chain-reactor template'

      def run
        puts <<-eos
#####################
#     Chainfile     #
#####################
 
# Do something when 127.0.0.1 sends a JSON
react_to('127.0.0.1') do |data|

  # The JSON string sent by the client is now a ruby hash
  puts data.inspect

end

# Use the same reaction for multiple clients, and require keys to exist
react_to( ['127.0.0.1','192.168.0.2'], :requires => [:mykey] ) do |data|

  # You can be sure this exists
  puts data[:mykey]

end

# Change the parser, if the client sends something other than a JSON
react_to('192.168.0.2', :parser => :xml_simple) do |data|

  # The XML string sent by the client is now a ruby hash
  puts data.inspect

end

## Everything from here on is optional, and  can be overridden 
## by equivalent command line parameters

## Address to bind to
address '127.0.0.1'

## Port to listen on
port 20000

## Location of pid file, for daemon
# pidfile '/var/run/chain-reactor.pid'

## Location of log file, for daemon
# logfile '/var/log/chain-reactor.log'

## Whether to accept each client in a separate thread.
# multithreaded true

        eos
      end
    end
  end

end
