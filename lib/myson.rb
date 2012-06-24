require "myson/version"
require "myson/parser"

module Myson
  def self.parse(json)
    parser = Parser.new(json)
    parser.parse()
  end
end
