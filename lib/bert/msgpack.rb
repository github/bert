require "msgpack"

module BERT
  def self.msgpack
    factory = MessagePack::Factory.new
    factory.register_type 0x00, BERT::Tuple, :packer => :to_msgpack
    factory.register_type 0x01, Symbol
    factory.register_type 0x02, Regexp,
      :packer => lambda { |regexp| [regexp.options, regexp.source].pack("Lm") },
      :unpacker => lambda { |raw| options, source = raw.unpack("Lm"); Regexp.new(source, options) }
    factory.register_type 0x03, Time,
      :packer => lambda { |time| [time.to_f].pack("G") },
      :unpacker => lambda { |raw| Time.at(raw.unpack("G").first) }
    factory.register_type 0x04, String,
      :packer => :to_bert_v3,
      :unpacker => :from_bert_v3
    return factory
  end
end

class String
  def to_bert_v3
    case encoding
    when ::Encoding::ASCII_8BIT
      ["b", b].pack("AA*")
    when ::Encoding::UTF_8
      ["u", b].pack("AA*")
    else
      enc_s = encoding.to_s
      ["_", enc_s.size, enc_s, b].pack("ASA*A*")
    end
  end

  def self.from_bert_v3(raw)
    io = StringIO.new(raw.b)
    tag = io.read(1)
    case tag
    when "b"
      io.read
    when "u"
      io.read.force_encoding(::Encoding::UTF_8)
    else
      encsize = io.read(2).unpack("S").first
      enc_s = io.read(encsize)
      str = io.read
      str.force_encoding(enc_s)
    end
  end
end
