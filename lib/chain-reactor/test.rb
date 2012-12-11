module ChainReactor

  lib_dir = File.dirname(__FILE__)
  $:.unshift lib_dir

  require "version"

  require 'log4r'
  require 'rubygems'
  require 'conf'

  include Log4r

  log = Logger.new 'chain-reactor'
  log.level = DEBUG

  log.outputters << Outputter.stdout
#
#  reactor = ChainfileParser.new(File.new('/home/jon/chainfile.rb'),log).parse
#  server = Server.new('127.0.0.1',20000,reactor,log)
#  server.start(false)
  require 'controller'
  conf = Conf.instance
  conf.address = '192.168.0.3'
  conf.port = 20123

  Controller.pid_file "/home/jon/chain-reactor.pid"
  Controller.start!
end
