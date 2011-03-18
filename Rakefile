require 'rake'

require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'rspec/core/rake_task'
  desc 'Run RSpec suite.'
  RSpec::Core::RakeTask.new('spec')
rescue LoadError
  puts "RSpec is not available. In order to run specs, you must: gem install rspec"
end

task :default => :spec