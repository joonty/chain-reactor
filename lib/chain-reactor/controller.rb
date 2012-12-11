module ChainReactor
  module Controller
    require 'fallen'
    require 'fallen/cli'
    require 'log4r'
    require 'server'
    require 'chainfile_parser'
    require 'conf'

    include Log4r

    extend Fallen
    extend Fallen::CLI

    def self.run
      begin
        log = Logger['chain-reactor']

        config = Conf.instance
        reactor = ChainfileParser.new(config.chainfile,log).parse
        server = Server.new(config.address,config.port,reactor,log)
        server.start(config.multithreaded?)
        puts "Ending, like a boss"
      rescue Exception => e
        puts "Caught exception"
        puts e.message
      end
    end
  end
end
