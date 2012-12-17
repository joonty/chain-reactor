require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

# Test task ----------------------------

Rake::TestTask.new do |t|
  t.libs << 'lib/chain-reactor'
  t.libs << 'test'
  t.libs << 'bin'
end

desc "Run tests"
task :default => :test

# RDoc task ----------------------------

rd = RDoc::Task.new("rdoc") { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "Chain Reactor"
  rdoc.options << '--line-numbers' << '--main' << 'README.rdoc'
  rdoc.rdoc_files.include('lib/**/*.rb', '[A-Z]*\.[a-z]*')
}

