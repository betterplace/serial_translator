ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :fakes, force: true do |t|
    t.text :description_translations
    t.text :title_translations
    t.text :subtitle_translations
    t.text :summary_translations
    t.text :credits_translations
    t.text :imprint_translations
  end
end

class Fake < ActiveRecord::Base
  include SerialTranslator

  # Has to be set in this context to test it correctly
  I18n.available_locales = [:en, :de, :'en-GB']

  serial_translator_for(*%w(description title subtitle summary credits imprint))

  validates :description, serial_translator_presence: true
  validates :title,       serial_translator_length: { within: 5..25 }
  validates :subtitle,    serial_translator_length: { is: 9,     allow_nil:   true }
  validates :summary,     serial_translator_length: { in: 5..25, allow_blank: true }
  validates :credits,     serial_translator_length: { minimum: 100 }
  validates :imprint,     serial_translator_length: { maximum: 100 }
end
