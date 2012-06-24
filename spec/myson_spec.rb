require 'spec_helper'

describe Myson do
  def self.parse_and_generate_spec(file)
    lines = File.readlines(file)
    lines = lines.map{ |line| line.strip }
    lines = lines.select{ |line| line != '' && line[0...1] != '#' }
    lines = lines.map{ |line| line.split(' ')}
    lines.each do |json, ruby|
      if ruby == 'error'
        it "should parse `#{json}' and raise error" do
          expect { Myson.parse(json)}.to raise_error
        end
      else
        it "should parse `#{json}' to #{ruby}" do
          Myson.parse(json).should == eval(ruby)
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
  end
end
