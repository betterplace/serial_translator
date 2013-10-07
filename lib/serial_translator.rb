require 'active_support'
require 'active_model'
require 'serial_translator/version'
require 'serial_translator/serial_translator_validator'

module SerialTranslator
  extend ActiveSupport::Concern

  included do
    attr_writer :current_translation_locale, :translation_fallback
  end

  module ClassMethods
    attr_reader :serial_translator_attributes

    def serial_translator_for(*attributes)
      @serial_translator_attributes = attributes

      attributes.each do |attribute|
        serialize :"#{attribute}_translations", Hash

        define_method attribute do |locale = current_translation_locale|
          translations = translations_for(attribute)
          result = translations[locale] if translations[locale].present?
          result ||= translations.values.detect(&:present?) if translation_fallback?
          result
        end

        define_method "#{attribute}=" do |value|
          translations = translations_for(attribute)
          translations[current_translation_locale] = value
          __send__(:"#{attribute}_translations=", translations)
        end
      end
    end
  end

  def current_translation_locale
    (@current_translation_locale || I18n.locale).to_sym
  end

  def translation_fallback?
    @translation_fallback != false
  end

  def translated_locales
    result = []
    self.class.serial_translator_attributes.each do |attribute|
      translations = translations_for(attribute).select { |_, value| value.present? }
      result += translations.keys
    end
    result.uniq
  end

  def translations_for(attribute)
    __send__(:"#{attribute}_translations") || {}
  end

  def translated_into?(locale)
    translated_locales.include?(locale.to_sym)
  end
end
