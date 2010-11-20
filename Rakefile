require "rubygems"
require "bundler"
Bundler.setup

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rspec/core/rake_task'

desc "Default Task"
task :default => [ :spec ]

# run all rspecs
desc "Run all rspec files"
RSpec::Core::RakeTask.new("spec") do |t|
  t.rspec_opts  = ["--color", "--format progress"]
  t.ruby_opts = "-w"
end

# Genereate the RDoc documentation
desc "Create documentation"
Rake::RDocTask.new("doc") do |rdoc|
  rdoc.title = "RBook"
  rdoc.rdoc_dir = (ENV['CC_BUILD_ARTIFACTS'] || 'doc') + '/rdoc'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('COPYING')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << "--inline-source"
end
