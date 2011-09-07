require 'rubygems'
require 'bundler'
Bundler.setup
require 'binary_plist'
require 'rspec/core/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color']
end

task :default => :spec
