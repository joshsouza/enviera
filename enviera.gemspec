# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enviera'

Gem::Specification.new do |gem|
  gem.name          = "enviera"
  gem.version       = Enviera::VERSION
  gem.description   = "Puppet tool for looking up all Hiera values for a given set of facts"
  gem.summary       = "Given an environment, looks up Hiera data about it. Env(ironment H)iera(chy)"
  gem.author        = "Josh Souza"
  gem.email         = "development@pureinsomnia.com"
  gem.license       = "MIT"

  gem.homepage      = "http://github.com/joshsouza/enviera"
  gem.files         = `git ls-files`.split($/).reject { |file| file =~ /^features.*$/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('trollop', '~> 2.0')
  gem.add_dependency('json', '~> 1.5')
  gem.add_dependency('hiera', '~> 1.3')
end