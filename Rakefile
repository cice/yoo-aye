require 'rake'

require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'rspec/core/rake_task'
  desc 'Run RSpec suite.'
  RSpec::Core::RakeTask.new('spec')

  desc  "Run all specs with rcov"
  RSpec::Core::RakeTask.new("rcov") do |t|
    t.rcov = true
    t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
  end
rescue LoadError
  puts "RSpec is not available. In order to run specs, you must: gem install rspec"
end

task :default => :spec