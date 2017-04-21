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
    return factory
  end
end
