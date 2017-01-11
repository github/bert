require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'ext', 'bert', 'c'))

load 'bert.rb'

if ENV.key?("BERT_TEST_IMPL") && ENV["BERT_TEST_IMPL"] != BERT::Decode.impl
  raise "Incorrect implementation loaded for value of BERT_TEST_IMPL environment variable! " +
        "Wanted #{ENV["BERT_TEST_IMPL"]}, but loaded #{BERT::Decode.impl}."
end

puts "Using #{BERT::Decode.impl} implementation."
