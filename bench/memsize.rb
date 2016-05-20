require 'bert'
require 'objspace'

large = ["abc" * 1000] * 10000

def write_berp(output, ruby)
  data = BERT.encode(ruby)
  output.write([data.bytesize].pack("N"))
  output.write(data)
end

def write_berp2(output, ruby)
  data = BERT.encode_to_buffer(ruby)
  output.write([data.bytesize].pack("N"))
  data.write_to output
end

socket = File.open File::NULL, 'wb' do |f|
  GC.start; GC.start; GC.start; GC.disable

  before = ObjectSpace.memsize_of_all(String)
  write_berp f, large
  p :ORIGINAL => ObjectSpace.memsize_of_all(String) - before

  GC.start; GC.start; GC.start; GC.disable
  before = ObjectSpace.memsize_of_all(String)
  write_berp2 f, large
  p :NEW => ObjectSpace.memsize_of_all(String) - before
end
