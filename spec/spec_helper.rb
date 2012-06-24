# class A
#   x = [1,2,3]
# end
# 
# class B < A
#   def self.f
#     p x
#   end
# end
# 
# B.f

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'myson'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
