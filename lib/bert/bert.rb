require "mochilo/version"

module BERT
  def self.supports?(v)
    case v
    when :v1, :v2
      true
    when :v3
      Mochilo.respond_to?(:pack_unsafe)
    when :v4
      !Mochilo.respond_to?(:pack_unsafe)
    else
      false
    end
  end

  def self.encode(ruby)
    Encoder.encode(ruby)
  end

  def self.encode_to_buffer(ruby)
    Encoder.encode_to_buffer(ruby)
  end

  def self.decode(bert)
    Decoder.decode(bert)
  end

  def self.ebin(str)
    bytes = []
    str.each_byte { |b| bytes << b.to_s }
    "<<" + bytes.join(',') + ">>"
  end

  class Tuple < Array
    def inspect
      "t#{super}"
    end
  end
end
