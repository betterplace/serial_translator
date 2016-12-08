# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'serial_translator/version'

Gem::Specification.new do |spec|
  spec.name          = "serial_translator"
  spec.version       = SerialTranslator::VERSION
  spec.authors       = ["betterplace development team"]
  spec.email         = ["developers@betterplace.org"]
  spec.description   = %q{Translate attribute values without additional models}
  spec.summary       = %q{Translate attribute values without additional models}
  spec.homepage      = "http://www.betterplace.org"
  spec.license       = "WTFPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-collection_matchers'
  spec.add_development_dependency 'simplecov'
end
