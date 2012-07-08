# -*- encoding: utf-8 -*-
require File.expand_path('../lib/myson/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jacob Dam"]
  gem.email         = ["jdam@digication.com"]
  gem.description   = %q{JSON parser}
  gem.summary       = %q{JSON parser using racc}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "myson"
  gem.require_paths = ["lib"]
  gem.version       = Myson::VERSION

  gem.add_runtime_dependency('racc')
  gem.add_runtime_dependency('rlex')
  
  gem.add_development_dependency('rspec', '~> 2.10')
  gem.add_development_dependency('rake')
end
