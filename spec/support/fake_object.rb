# This class is only used for testing purposes.
class FakeObject
  include ActiveModel::Validations

  def self.serialize(*) ; end
  def self.before_save(*) ; end

  attr_accessor :title_translations, :description_translations, :summary_translations

  # Has to be set in this context to test it correctly
  I18n.available_locales = [:en, :de, :'en-GB']

  def changes
    @changes ||= []
  end

  def mark_change(attribute)
    changes << attribute
  end

  def description_translations_will_change!
    mark_change :description_translations
  end

  def title_translations_will_change!
    mark_change :title_translations
  end

  def summary_translations_will_change!
    mark_change :summary_translations
  end

  include SerialTranslator
  serial_translator_for :title, :description, :summary
  validates :title,       serial_translator: { length: 5..25 }
  validates :description, serial_translator: { presence: true }
end
