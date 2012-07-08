require "myson/version"
require "myson/lexer"
require "myson/parser"

module Myson
  def self.parse(json)
    parser = Parser.new(json)
    parser.parse()
  end
end
