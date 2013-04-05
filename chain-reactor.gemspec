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

  gem.add_runtime_dependency 'rake', '~> 0.8.7'
  gem.add_runtime_dependency 'main', '~> 5.1.1'
  gem.add_runtime_dependency 'json', '~> 1.7.5'
  gem.add_runtime_dependency 'dante', '~> 0.1.5'
  gem.add_runtime_dependency 'log4r', '~> 1.1.10'
  gem.add_runtime_dependency 'rdoc', '~> 3.12'
  gem.add_runtime_dependency 'xml-simple', '~> 1.1.2'

  gem.add_development_dependency 'test-unit', '~> 2.5.3'
  gem.add_development_dependency 'mocha', '~> 0.13.1'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = %w(chain-reactor chain-reactor-client)
  gem.test_files    = `git ls-files -- test/test_`.split($/)
  gem.require_paths = ["lib"]
end
