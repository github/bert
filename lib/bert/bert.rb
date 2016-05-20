module BERT
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
