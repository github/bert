require 'rubygems'
require 'rake'

require 'rake/extensiontask'

gemspec = Gem::Specification::load(File.expand_path('../bert.gemspec', __FILE__))

Rake::ExtensionTask.new(gemspec) do |ext|
  ext.name = 'decode'
  ext.ext_dir = 'ext/bert/c'
  ext.lib_dir = 'ext/bert/c'
end

require 'rake/testtask'
Rake::TestTask.new(:runtests) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => [:compile, :test]

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
  t.warning = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bert #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :console do
  exec('irb -I lib -rbert')
end
