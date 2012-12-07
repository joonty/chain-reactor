require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/chain-reactor'
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
