module ChainReactor
  module Controller
    require 'fallen'
    require 'log4r'

    include Log4r

    extend Fallen

    def self.run
      puts "Monkeys"
      log = Logger.new 'chain-reactor'
      log.level = ::Logger::DEBUG

      log.outputters << Outputter.stdout

      reactor = ChainfileParser.new(File.new('/home/jon/chainfile.rb'),log).parse
      server = Server.new('127.0.0.1',20000,reactor,log)
      server.start(false)
      puts "Ending, like a boss"
    end
  end
end
