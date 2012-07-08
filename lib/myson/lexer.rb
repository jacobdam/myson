# encoding: utf-8

require 'rlex'

module Myson
  class Lexer
    def initialize(input)
      rlex.start input
    end

    def next_token
      token = rlex.next_token
      case token.type
      when :NUMBER
        token.value = token.value.match(/[\.eE]/) ? token.value.to_f : token.value.to_i
      when :STRING
        s = token.value[1...-1]
        s = s.gsub(/[^"\\]|\\u[0-9a-fA-z]{4}|\\[^u]/) do |c|
          if c[0..0] == '\\'
            case c[1..1]
            when 'b' then "\b"
            when 'f' then "\f"
            when 'n' then "\n"
            when 'r' then "\r"
            when 't' then "\t"
            when 'u' then make_unicode_char(c[2..-1].hex)
            else c[1..1]
            end
          else
            c
          end
        end
        token.value = s
      end

      token
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


    private
      def rlex
        @rlex ||=  begin
          lexer = Rlex::Lexer.new
          lexer.ignore /\s+/
          lexer.rule :NUMBER, %r{\-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][\-+]?[0-9]+)?}
          lexer.rule :STRING, %r{"([^"\\]|\\u[0-9a-fA-z]{4}|\\[^u])*"}
          [':', ',', '{', '}', '[', ']', 'null', 'true', 'false'].each do |keyword|
            lexer.keyword keyword
          end

          lexer
        end
      end
  end
end
