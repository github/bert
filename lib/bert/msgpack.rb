require "msgpack"

module BERT
  def self.msgpack
    factory = MessagePack::Factory.new
    factory.register_type(0x00, Symbol)
    factory
  end
end
