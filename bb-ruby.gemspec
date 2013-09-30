# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bb-ruby/version'

Gem::Specification.new do |gem|
  gem.name          = "bb-ruby"
  gem.version       = BBRuby::VERSION
  gem.authors       = ["Craig P. Jolicoeur"]
  gem.email         = ["cpjolicoeur@gmail.com"]
  gem.description   = %q{BBCode for Ruby}
  gem.summary       = %q{BBRuby is a BBCode implementation for Ruby. It will convert strings with BBCode markup to their HTML equivalent}
  gem.homepage      = "http://cpjolicoeur.github.io/bb-ruby/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
