require 'simplecov'

SimpleCov.adapters.define 'gem' do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'serial_translator'
require 'active_model'
require 'active_resource'
require 'support/validations_matcher'
require 'support/fake_object'
