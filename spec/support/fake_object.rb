# This class is only used for testing purposes.
class FakeObject
  include ActiveModel::Validations
  include SerialTranslator

  def self.serialize(*); end

  def self.before_save(*); end

  # Has to be set in this context to test it correctly
  I18n.available_locales = [:en, :de, :'en-GB']

  TRANSLATED_ATTRIBUTES = %w(description title subtitle summary credits imprint)

  serial_translator_for(*TRANSLATED_ATTRIBUTES)

  TRANSLATED_ATTRIBUTES.map {|ta| "#{ta}_translations" }.each do |hash_name|
    attr_accessor hash_name
    define_method("#{hash_name}_will_change!") { changes << hash_name.to_sym }
  end

  def changes
    @changes ||= []
  end

  validates :description, serial_translator_presence: true
  validates :title,       serial_translator_length: { within: 5..25 }
  validates :subtitle,    serial_translator_length: { is: 9,     allow_nil:   true }
  validates :summary,     serial_translator_length: { in: 5..25, allow_blank: true }
  validates :credits,     serial_translator_length: { minimum: 100 }
  validates :imprint,     serial_translator_length: { maximum: 100 }
end
