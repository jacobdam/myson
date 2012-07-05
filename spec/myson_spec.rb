require 'spec_helper'

describe Myson do
  def self.parse_and_generate_spec(file)
    lines = File.readlines(file)
    
    directives = []
    directives = lines.shift.split(' ').map{ |d| d.gsub('@', '') } if lines.first[0...1] == '@'
    
    if directives.include?('singleline')
      lines = lines.map{ |line| line.strip }
      lines = lines.select{ |line| line != '' && line[0...1] != '#' }
      specs = lines.map{ |line|
        json, ruby = line.split(/\s+/)
        
        [json.strip, ruby.strip]
      }
    elsif directives.include?('linepair')
      specs = []
      json = nil
      ruby = nil
      lines.each do |line|
        if line.match(/^=>/)
          ruby = line.gsub(/^=>/, '').strip
        else
          json = line.strip
        end
        
        if ruby
          raise "Invalid specs file: `#{file}'" if json == nil
          specs << [json, ruby]
          json = nil
          ruby = nil
        end
      end
    else
      raise "Invalid specs file: `#{file}'"
    end
    
    specs.each do |json, ruby|
      j, r = json, ruby
      if ruby == 'error'
        it "should parse `#{json}' and raise error" do
          if directives.include?('array_wrapper')
            expect{ Myson.parse('[' + j + ']') }.to raise_error
          else
            expect{ Myson.parse(j) }.to raise_error
          end
        end
      else
        it "should parse `#{json}' to #{ruby}" do
          if directives.include?('array_wrapper')
            Myson.parse('[' + j + ']').should == [eval(r)]
          else
            Myson.parse(j).should == eval(r)
          end
        end
      end
    end
  end
  
  describe '.parse' do
    context 'constant' do
      parse_and_generate_spec(File.dirname(__FILE__) + '/constant_spec.txt')
    end
    
    context 'number' do
      parse_and_generate_spec(File.dirname(__FILE__) + '/number_spec.txt')
    end
    
    context 'array' do
      parse_and_generate_spec(File.dirname(__FILE__) + '/array_spec.txt')
    end

    context 'string' do
      parse_and_generate_spec(File.dirname(__FILE__) + '/string_spec.txt')
      
      if RUBY_VERSION >= '1.9'
        it %Q{should parse `"unicode \u1234" to "unicode \u1234"'} do
          Myson.parse('["unicode \u1234"]').should == ["unicode \u1234"]
        end
      else
        it %Q{should parse `"unicode \\u0024 \\u00A2 \\u20AC" to "unicode \\x24 \\xC2\\xA2 \\xE2\\x82\\xAC"'} do
          Myson.parse('["unicode \u0024 \u00A2 \u20AC"]').should == ["unicode \x24 \xC2\xA2 \xE2\x82\xAC"]
        end
      end
    end

    context 'object' do
      parse_and_generate_spec(File.dirname(__FILE__) + '/object_spec.txt')
    end

    context 'document' do
      parse_and_generate_spec(File.dirname(__FILE__) + '/document_spec.txt')
    end
  end
end
