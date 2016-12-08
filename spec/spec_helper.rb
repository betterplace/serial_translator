require 'simplecov'

SimpleCov.profiles.define 'gem' do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'serial_translator'
require 'active_model'
require 'support/fake_object'
require 'rspec/collection_matchers'
