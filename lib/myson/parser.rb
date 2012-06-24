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
        
        c_type = case
        when KNOWN_TOKENS then c
        else :OTHER
        end
        
        [c_type, c]
      end
  end
end
