# encoding: utf-8

require 'myson/generated_parser'

module Myson
  class Parser < GeneratedParser
    def initialize(json)
      @lexer = Lexer.new(json)
    end
    
    def parse
      do_parse
    end
    
    protected
      def next_token
        token = @lexer.next_token
        return nil if token.type == :eof

        case token.type
        when :NUMBER, :STRING
          [token.type, token.value]
        else
          [token.type.to_s, token.value]
        end
      end
  end
end
