# -*- encoding: utf-8 -*-

if ENV['DEVELOPMENT']
  VERSION = `git describe --tags`.strip.gsub('-', '.')[1..-1]
else
  VERSION = File.read('VERSION')
end

Gem::Specification.new do |s|
    s.name = "bert"
    s.version = VERSION
    s.summary = %Q{BERT Serializiation for Ruby}
    s.description = %Q{BERT Serializiation for Ruby}
    s.license = "MIT"
    s.email = "tom@mojombo.com"
    s.homepage = "http://github.com/github/bert"
    s.authors = ["Tom Preston-Werner"]

    s.files = `git ls-files`.split("\n")
    s.require_paths = ["lib", "ext"]

    s.extensions = ["ext/bert/c/extconf.rb"]

    s.add_development_dependency "thoughtbot-shoulda"
    s.add_development_dependency "git"
    s.add_development_dependency "rake"
    s.add_development_dependency "rake-compiler", "~> 0.9.0"
    s.add_development_dependency "yajl"
end
