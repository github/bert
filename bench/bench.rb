$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bert'
require 'json'
require 'msgpack'
require 'yajl'
require 'benchmark'

ITER = 1_000

tiny = t[:ok, :awesome]
small = t[:ok, :answers, [42] * 42]
large = ["abc" * 1000] * 100
complex = [42, {:foo => 'bac' * 100}, t[(1..100).to_a]] * 10
long_array = {:a => ["a"]*1000}

Benchmark.bm(30) do |bench|
  [:v1, :v2, :v3, :v4].each do |v|
    BERT::Encode.version = v
    bench.report("BERT #{v} tiny") {ITER.times {BERT.decode(BERT.encode(tiny))}}
    bench.report("BERT #{v} small") {ITER.times {BERT.decode(BERT.encode(small))}}
    bench.report("BERT #{v} large") {ITER.times {BERT.decode(BERT.encode(large))}}
    bench.report("BERT #{v} complex") {ITER.times {BERT.decode(BERT.encode(complex))}}
    bench.report("BERT #{v} long array") {ITER.times {BERT.decode(BERT.encode(long_array))}}
  end

  bench.report("JSON tiny") {ITER.times {JSON.load(JSON.dump(tiny))}}
  bench.report("JSON small") {ITER.times {JSON.load(JSON.dump(small))}}
  bench.report("JSON large") {ITER.times {JSON.load(JSON.dump(large))}}
  bench.report("JSON complex") {ITER.times {JSON.load(JSON.dump(complex))}}
  bench.report("JSON long array") {ITER.times {JSON.load(JSON.dump(long_array))}}

  bench.report("YAJL tiny") {ITER.times {Yajl::Parser.parse(Yajl::Encoder.encode(tiny))}}
  bench.report("YAJL small") {ITER.times {Yajl::Parser.parse(Yajl::Encoder.encode(small))}}
  bench.report("YAJL large") {ITER.times {Yajl::Parser.parse(Yajl::Encoder.encode(large))}}
  bench.report("YAJL complex") {ITER.times {Yajl::Parser.parse(Yajl::Encoder.encode(complex))}}
  bench.report("YAJL long array") {ITER.times {Yajl::Parser.parse(Yajl::Encoder.encode(long_array))}}

  bench.report("Ruby tiny") {ITER.times {Marshal.load(Marshal.dump(tiny))}}
  bench.report("Ruby small") {ITER.times {Marshal.load(Marshal.dump(small))}}
  bench.report("Ruby large") {ITER.times {Marshal.load(Marshal.dump(large))}}
  bench.report("Ruby complex") {ITER.times {Marshal.load(Marshal.dump(complex))}}
  bench.report("Ruby long array") {ITER.times {Marshal.load(Marshal.dump(long_array))}}

  bench.report("Msgpack tiny") {ITER.times {MessagePack.unpack(MessagePack.pack(tiny))}}
  bench.report("Msgpack small") {ITER.times {MessagePack.unpack(MessagePack.pack(small))}}
  bench.report("Msgpack large") {ITER.times {MessagePack.unpack(MessagePack.pack(large))}}
  bench.report("Msgpack complex") {ITER.times {MessagePack.unpack(MessagePack.pack(complex))}}
  bench.report("Msgpack long array") {ITER.times {MessagePack.unpack(MessagePack.pack(long_array))}}
end
