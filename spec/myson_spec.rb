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
          expect{ Myson.parse(example.metadata['json']) }.to raise_error
        end
      else
        it "should parse `#{json}' to #{ruby}" do
          Myson.parse(j).should == eval(r)
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
  end
end
