require 'simplecov'

SimpleCov.profiles.define 'gem' do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'serial_translator'
require 'rspec/collection_matchers'
require 'support/fake_env'
require 'active_record'
