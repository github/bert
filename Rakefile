require 'rubygems'
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:runtests) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :make do
  Dir.chdir('ext/bert/c') { `ruby extconf.rb`; `make` }
end

task :clean do
  ['rm -f ext/bert/c/*.bundle', 'rm -f ext/bert/c/*.o'].each do |cmd|
    `#{cmd}` && puts(cmd)
  end
end

task :test do
  require 'fileutils'

  puts "\nCleaning extension build files and running all specs in native ruby mode..."
  ['rm -f ext/bert/c/*.bundle', 'rm -f ext/bert/c/*.o'].each do |cmd|
    `#{cmd}` && puts(cmd)
  end
  pid = fork do
    exec 'rake runtests'
  end
  Process.waitpid(pid)

  puts "\nRunning `make` to build extensions and rerunning decoder specs..."
  Dir.chdir('ext/bert/c') { `ruby extconf.rb`; `make` }
  pid = fork do
    exec 'rake runtests'
  end
  Process.waitpid(pid)
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
