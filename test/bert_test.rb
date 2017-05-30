# coding: utf-8
require 'test_helper'

class BertTest < Test::Unit::TestCase
  context "BERT" do
    setup do
      time = Time.at(1254976067).utc
      @ruby = t[:user, {:name => 'TPW'}, [/cat/i, 9.9], time, nil, true, false, :true, :false]
      @bert_v1 = "\203h\td\000\004userh\003d\000\004bertd\000\004dictl\000\000\000\001h\002d\000\004namem\000\000\000\003TPWjl\000\000\000\002h\004d\000\004bertd\000\005regexm\000\000\000\003catl\000\000\000\001d\000\bcaselessjc9.900000000000000e+00\000\000\000\000\000\000\000\000\000\000jh\005d\000\004bertd\000\004timeb\000\000\004\346b\000\016\344\303a\000h\002d\000\004bertd\000\003nilh\002d\000\004bertd\000\004trueh\002d\000\004bertd\000\005falsed\000\004trued\000\005false".b
      @ebin_v1 = "<<131,104,9,100,0,4,117,115,101,114,104,3,100,0,4,98,101,114,116,100,0,4,100,105,99,116,108,0,0,0,1,104,2,100,0,4,110,97,109,101,109,0,0,0,3,84,80,87,106,108,0,0,0,2,104,4,100,0,4,98,101,114,116,100,0,5,114,101,103,101,120,109,0,0,0,3,99,97,116,108,0,0,0,1,100,0,8,99,97,115,101,108,101,115,115,106,99,57,46,57,48,48,48,48,48,48,48,48,48,48,48,48,48,48,101,43,48,48,0,0,0,0,0,0,0,0,0,0,106,104,5,100,0,4,98,101,114,116,100,0,4,116,105,109,101,98,0,0,4,230,98,0,14,228,195,97,0,104,2,100,0,4,98,101,114,116,100,0,3,110,105,108,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101,100,0,4,116,114,117,101,100,0,5,102,97,108,115,101>>"
      @berts = {
        :v2 => "\x84h\td\x00\x04userh\x03d\x00\x04bertd\x00\x04dictl\x00\x00\x00\x01h\x02d\x00\x04nameq\x00\x00\x00\x03TPWjl\x00\x00\x00\x02h\x04d\x00\x04bertd\x00\x05regexq\x00\x00\x00\x03catl\x00\x00\x00\x01d\x00\bcaselessjc9.900000000000000e+00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00jh\x05d\x00\x04bertd\x00\x04timeb\x00\x00\x04\xE6b\x00\x0E\xE4\xC3a\x00h\x02d\x00\x04bertd\x00\x03nilh\x02d\x00\x04bertd\x00\x04trueh\x02d\x00\x04bertd\x00\x05falsed\x00\x04trued\x00\x05false".b,
        :v3 => "\x85\x99\xD4\x04user\x81\xD4\x04name\xD8\x00\x03\x00TPW\x92\xD5\x00\x03\x00\x00\x00\x01\x01cat\xCB@#\xCC\xCC\xCC\xCC\xCC\xCD\xD6\x00\x00\x00\x00\x4A\xCD\x6A\x43\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xC0\xC3\xC2\xD4\x04true\xD4\x05false".b,
        :v4 => "\x86\x99\xC7\x05\xFF\x00user\x81\xC7\x05\xFF\x00name\xA3TPW\x92\xC7\x09\xFF\x01\x00\x00\x00\x01\x01cat\xCB@#\xCC\xCC\xCC\xCC\xCC\xCD\xC7\x15\xFF\x02\x00\x00\x00\x00\x4A\xCD\x6A\x43\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xC0\xC3\xC2\xC7\x05\xFF\x00true\xC7\x06\xFF\x00false".b,
      }
      @ebins = {
        :v2 => "<<132,104,9,100,0,4,117,115,101,114,104,3,100,0,4,98,101,114,116,100,0,4,100,105,99,116,108,0,0,0,1,104,2,100,0,4,110,97,109,101,113,0,0,0,3,84,80,87,106,108,0,0,0,2,104,4,100,0,4,98,101,114,116,100,0,5,114,101,103,101,120,113,0,0,0,3,99,97,116,108,0,0,0,1,100,0,8,99,97,115,101,108,101,115,115,106,99,57,46,57,48,48,48,48,48,48,48,48,48,48,48,48,48,48,101,43,48,48,0,0,0,0,0,0,0,0,0,0,106,104,5,100,0,4,98,101,114,116,100,0,4,116,105,109,101,98,0,0,4,230,98,0,14,228,195,97,0,104,2,100,0,4,98,101,114,116,100,0,3,110,105,108,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101,100,0,4,116,114,117,101,100,0,5,102,97,108,115,101>>",
        :v3 => "<<133,153,212,4,117,115,101,114,129,212,4,110,97,109,101,216,0,3,0,84,80,87,146,213,0,3,0,0,0,1,1,99,97,116,203,64,35,204,204,204,204,204,205,214,0,0,0,0,74,205,106,67,0,0,0,0,0,0,0,0,0,0,0,0,192,195,194,212,4,116,114,117,101,212,5,102,97,108,115,101>>",
        :v4 => "<<134,153,199,5,255,0,117,115,101,114,129,199,5,255,0,110,97,109,101,163,84,80,87,146,199,9,255,1,0,0,0,1,1,99,97,116,203,64,35,204,204,204,204,204,205,199,21,255,2,0,0,0,0,74,205,106,67,0,0,0,0,0,0,0,0,0,0,0,0,192,195,194,199,5,255,0,116,114,117,101,199,6,255,0,102,97,108,115,101>>",
      }
    end

    should "support either v3 or v4" do
      assert BERT.supports?(:v3) || BERT.supports?(:v4)
    end

    [:v2, :v3, :v4].each do |v|
      context "#{v} encoder" do
        setup do
          @old_version = BERT::Encode.version
          BERT::Encode.version = v
          @bert = @berts.fetch(v)
          @ebin = @ebins.fetch(v)
        end

        teardown do
          BERT::Encode.version = @old_version
        end

        should "decode new format" do
          pend unless BERT.supports?(v)
          assert_equal @ruby, BERT.decode(@bert)
        end

        should "roundtrip string and maintain encoding" do
          pend unless BERT.supports?(v)
          str = "日本語".encode 'EUC-JP'
          round = BERT.decode(BERT.encode(str))
          assert_equal str, round
          assert_equal str.encoding, round.encoding
        end

        should "roundtrip binary string" do
          pend unless BERT.supports?(v)
          str = "日本語".b
          round = BERT.decode(BERT.encode(str))
          assert_equal str, round
          assert_equal str.encoding, round.encoding
        end

        should "encode" do
          pend unless BERT.supports?(v)
          assert_equal @bert, BERT.encode(@ruby)
        end

        should "roundtrip obj" do
          pend unless BERT.supports?(v)
          assert_equal @ruby, BERT.decode(BERT.encode(@ruby))
        end

        should "encode with buffer" do
          pend unless BERT.supports?(v)
          buf = BERT.encode_to_buffer(@ruby)
          io = StringIO.new
          io.set_encoding 'binary'
          buf.write_to io
          assert_equal @bert, io.string
        end

        should "ebin" do
          pend unless BERT.supports?(v)
          assert_equal @ebin, BERT.ebin(@bert)
        end

        should "raise on encode when unsupported" do
          pend if BERT.supports?(v)
          assert_raises do
            BERT.encode_to_buffer(@ruby)
          end
        end

        should "raise on decode when unsupported" do
          pend if BERT.supports?(v)
          assert_raises do
            BERT.decode(@bert)
          end
        end
      end
    end

    should "decode the old format" do
      assert_equal @ruby, BERT.decode(@bert_v1)
    end

    should "ebin" do
      assert_equal @ebin_v1, BERT.ebin(@bert_v1)
    end

    should "do roundtrips" do
      dd = []
      dd << 1
      dd << 1.0
      dd << :a
      dd << t[]
      dd << t[:a]
      dd << t[:a, :b]
      dd << t[t[:a, 1], t[:b, 2]]
      dd << []
      dd << [:a]
      dd << [:a, 1]
      dd << [[:a, 1], [:b, 2]]
      dd << "a"

      dd << nil
      dd << true
      dd << false
      dd << {}
      dd << {:a => 1}
      dd << {:a => 1, :b => 2}
      dd << Time.at(1484112000, 123456)
      dd << /^c(a)t$/i

      dd << 178
      dd << 256**256 - 1

      dd << :true
      dd << :false
      dd << :nil

      dd.each do |d|
        assert_equal d, BERT.decode(BERT.encode(d))
      end
    end

    # should "let me inspect it" do
    #   puts
    #   p @ruby
    #   ruby2 = BERT.decode(@bert)
    #   p ruby2
    #   bert2 = BERT.encode(ruby2)
    #   ruby3 = BERT.decode(bert2)
    #   p ruby3
    # end
  end
end
