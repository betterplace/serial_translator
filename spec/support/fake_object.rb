# This class is only used for testing purposes.
class FakeObject
  include ActiveModel::Validations
  def self.serialize(*) ; end
  def self.before_save(*) ; end
  attr_accessor :title_translations, :description_translations, :summary_translations

  include SerialTranslator
  serial_translator_for :title, :description, :summary
  validates :title,       serial_translator: { length: 5..25 }
  validates :description, serial_translator: { presence: true }
end
