require "chain-reactor/version"
require 'rubygems'
require 'yaml'
require 'server'
require 'conf'
require 'reactions'

module ChainReactor

  # Add current directory to require path
  lib_dir = File.dirname(__FILE__)
  $:.unshift lib_dir

  load File.expand_path('../reactions.rb',lib_dir)

  # Read configuration data from YAML file and load into Conf class.
  conf_file = File.expand_path('../config.yaml',lib_dir)
  conf_data = YAML.load_file(conf_file)
  Conf.load(conf_data)

  server = Server.new.start

end
