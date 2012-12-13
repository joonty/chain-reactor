# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chain-reactor/version'

Gem::Specification.new do |gem|
  gem.name          = "chain-reactor"
  gem.version       = ChainReactor::VERSION
  gem.license       = 'MIT'
  gem.authors       = ["Jon Cairns"]
  gem.email         = ["jon@joncairns.com"]
  gem.description   = %q{Trigger events across networks using TCP/IP sockets}
  gem.summary       = %q{A TCP/IP server that triggers code on connection}
  gem.homepage      = "http://github.com/joonty/chain-reactor"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = %w(chain-reactor chain-reactor-client)
  gem.test_files    = `git ls-files -- test/test_`.split($/)
  gem.require_paths = ["lib"]
end
