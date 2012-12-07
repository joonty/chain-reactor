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

    input :chainfile do
      description 'A valid chainfile - run with the template argument to create a template'
    end

    option :multithreaded do
      cast :bool
      defaults false
      description 'Whether to allow concurrent connections in separate threads'
    end

    option :log_file do
      argument :required
      description 'Log file to write messages to'
    end

    option :silent do
      cast :bool
      defaults false
      description 'Whether to suppress all messages to stdout'
    end

    option :debug do
      log_levels = %w(debug info warn error fatal)
      argument :required
      validate { |str| log_levels.include? str }
      synopsis '--debug=('+log_levels.join('|')+')  (0 ~> debug=info)'
      defaults 'info'
      description 'Type of messages to send to output'
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
      require 'server'
      require 'chainfile-parser'

      log = Logger.new 'chain-reactor'
      log.level = ChainReactor.const_get(params[:debug].value.upcase)

      unless params[:silent].value
        log.outputters << Outputter.stdout
      end

      if params[:log_file].value
        format = PatternFormatter.new(:pattern => "[%l] %d :: %m")
        fileoutputter = FileOutputter.new('chain-reactor',:filename => params[:log_file].value)
        fileoutputter.formatter = PatternFormatter.new(:pattern => "[%l] %d :: %m")
        log.outputters << fileoutputter
      end

      reactor = ChainfileParser.new(params[:chainfile].value,log).parse
      server = Server.new(params[:address].value,params[:port].value,reactor,log)
      server.start(params[:multithreaded].value)
    end

    mode 'template' do
      params[:chainfile].ignore!
      params[:multithreaded].ignore!
      params[:address].ignore!
      params[:port].ignore!
      params[:silent].ignore!
      params[:log_file].ignore!
      params[:debug].ignore!

      output :chainfile do
        description 'An output file location for the template'
      end

      def run
        chainfile = params[:chainfile].value
        chainfile.puts <<-eos
# Do something when 127.0.0.1 sends a JSON
react_to('127.0.0.1') do |data|
  puts data.inspect
end

# Use the same block for multiple addresses, and require JSON keys
react_to( ['127.0.0.1','192.168.0.2'], :requires => [:mykey] ) do |data|
  puts data[:mykey]
end
        eos
        puts "Written example chain file to #{chainfile.path}"
      end
    end

  end

end
