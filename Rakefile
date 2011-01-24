require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

spec_files = Rake::FileList['spec/*_spec.rb']

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  # t.spec_files = FileList['spec/*_spec.rb']
  t.rspec_opts = ['--color']
end

task :default => :spec
