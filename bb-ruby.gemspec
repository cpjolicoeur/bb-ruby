# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bb-ruby/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Craig P. Jolicoeur"]
  gem.email         = ["cpjolicoeur@gmail.com"]
  gem.description   = %q{BBCode for Ruby}
  gem.summary       = %q{BBRuby is a BBCode implementation for Ruby. It will convert strings with BBCode markup to their HTML equivalent}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bb-ruby"
  gem.require_paths = ["lib"]
  gem.version       = BBRuby::VERSION
end
