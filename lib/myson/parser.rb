# encoding: utf-8

require 'myson/generated_parser'

module Myson
  class Parser < GeneratedParser
    KNOWN_TOKENS = Myson::GeneratedParser::Racc_arg[10].keys.select{|k| k.is_a?(String) }
    
    def initialize(json)
      @input = StringIO.new(json)
    end
    
    def parse
      do_parse
    end
    
    protected
      def next_token
        c = @input.read(1)
        return nil if c == nil
        
        c_type = KNOWN_TOKENS.include?(c) ? c : :OTHER
        
        [c_type, c]
      end

      def make_unicode_char(code)
        if RUBY_VERSION >= '1.9'
          '' << code
        else
          utf8 = ''
          if code < 0x80
            utf8 << code
          elsif code < 0x800
            utf8 << (0xC0 | (code >> 6))
            utf8 << (0x80 | (code & 0x3F))
          else
            utf8 << (0xE0 | (code >> 12))
            utf8 << (0x80 | ((code >> 6) & 0x3F))
            utf8 << (0x80 | (code & 0x3F))
          end

          utf8
        end
      end
  end
end
