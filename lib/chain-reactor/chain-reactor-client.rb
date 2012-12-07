
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
      cli = Client.new params[:address].value, params[:port].value
      cli.send({:hello => 'world'})
    end
  end
end
