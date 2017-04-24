require "mochilo"

module BERT
  def self.mochilo
    @@mochilo ||= MochiloFactory.new
  end

  class MochiloFactory
    def pack(obj)
      Mochilo.pack(obj, custom_packers)
    end

    def unpack(str)
      Mochilo.unpack(str, custom_unpackers)
    end

    private

    def custom_packers
      Hash[ customizations.map { |customization| [customization.unpacked_class, [customization.type_id, customization.method(:pack)]] } ]
    end

    def custom_unpackers
      Hash[ customizations.map { |customization| [customization.type_id, customization.method(:unpack)] } ]
    end

    def customizations
      @customizations ||= [
        MochiloSymbol,
        MochiloRegexp,
        MochiloTime,
      ].map(&:new)
    end
  end

  class MochiloSymbol
    def unpacked_class
      Symbol
    end

    def type_id
      0x00
    end

    def pack(symbol)
      symbol.to_s
    end

    def unpack(str)
      str.to_sym
    end
  end

  class MochiloRegexp
    def unpacked_class
      Regexp
    end

    def type_id
      0x01
    end

    def pack(regexp)
      [regexp.options, regexp.source].pack("Lm")
    end

    def unpack(raw)
      options, source = raw.unpack("Lm")
      Regexp.new(source, options)
    end
  end

  class MochiloTime
    def unpacked_class
      Time
    end

    def type_id
      0x02
    end

    def pack(time)
      [time.to_f].pack("G")
    end

    def unpack(raw)
      Time.at(raw.unpack("G").first)
    end
  end
end
