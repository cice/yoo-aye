require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'sdoc'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the yoo_ay plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end




desc 'Generate documentation for the pagepal_ui plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Kudu UI Plugin'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rcov/rcovtask'

desc 'Output test coverage of plugin.'
Rcov::RcovTask.new do |rcov|
  rcov.test_files    = FileList['test/**/*_test.rb']
  rcov.libs << "test"
  rcov.rcov_opts << '--xrefs'
  rcov.verbose    = true
end


Rake::RDocTask.new(:sdoc) do |rdoc|
  unless ENV['RDOC_PATH'].is_a? String
    raise "You have to set the RDOC_PATH environment variable!"
  end
  rdoc.title = "Kudu UI Plugin"

  output_dir = ENV['RDOC_PATH'] + "/yoo_ay"
  rdoc.options << "--op=#{output_dir}"
  rdoc.rdoc_dir = output_dir
  rdoc.options << '--fmt' << 'shtml'
  rdoc.options << '--exclude' << '.*test.*'
  rdoc.options << '--exclude' << '.*db.*'
  rdoc.template = 'direct'
end
