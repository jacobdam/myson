require 'racc'

module Myson
  grammar = Racc::Grammar.define do
    self.document       = seq(:null) | seq(:array) | seq(:object)
    self.literal        = seq(:primitive) | seq(:array) | seq(:object)
    
    self.primitive      = seq(:boolean) | seq(:number) | seq(:string) | seq(:null)
    self.null           = seq('null') { |_| nil }
    self.boolean        = seq('false') { |_| false } |
                          seq('true') { |_| true }
    self.number         = seq(:NUMBER)
    self.string         = seq(:STRING)
    
    self.array          = seq('[', separated_by(',', :literal), ']') { |_, items, _| items }
    self.object         = seq('{', separated_by(',', :array_item), '}') { |_, items, _| Hash[items] }
    self.array_item     = seq(:string, ':', :literal) { |key, _, value| [key, value] }
  end

  Parser = grammar.parser_class
  class Parser
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
