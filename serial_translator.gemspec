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

  spec.add_dependency 'activemodel', '>= 5'
  spec.add_dependency 'activerecord', '>= 5'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-collection_matchers'
  spec.add_development_dependency 'json', '~>2'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3'
end
