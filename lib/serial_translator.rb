require 'active_support'
require 'active_model'
require 'active_record'

require 'serial_translator/serial_translator_length_validator'
require 'serial_translator/serial_translator_presence_validator'
require 'serial_translator/translation_type'
require 'serial_translator/version'

module SerialTranslator
  extend ActiveSupport::Concern

  included do
    attr_writer :current_translation_locale, :translation_fallback
  end

  class InvalidLocaleError < StandardError
  end

  module ClassMethods
    attr_reader :serial_translator_attributes

    def serial_translator_for(*attributes)
      @serial_translator_attributes = attributes

      attributes.each do |attr_name|
        attribute :"#{attr_name}_translations", SerialTranslator::TranslationType.new

        # Define the normal getter, that respects the
        # current translation locale
        define_method attr_name do |locale = current_translation_locale|
          translations = translations_for(attr_name)
          result = translations[locale] if translations[locale].present?
          result ||= translations.values.detect(&:present?) if translation_fallback?
          result
        end

        define_method :"#{attr_name}?" do |locale = current_translation_locale|
          __send__(attr_name.to_sym, locale).present?
        end

        # Define the normal setter, that respects the
        # current translation locale
        define_method "#{attr_name}=" do |value|
          unless I18n.available_locales.include?(current_translation_locale)
            raise InvalidLocaleError, "current_translation_locale #{current_translation_locale.inspect} is not a member of I18n.available_locales: #{I18n.available_locales.inspect}"
          end
          __send__(:"#{attr_name}_translations_will_change!")
          translations = translations_for(attr_name)

          value&.scrub!('')

          if value.present?
            translations[current_translation_locale] = value
          else
            translations.delete(current_translation_locale)
          end
          __send__(:"#{attr_name}_translations=", translations)
        end

        # Define getters for each specific available locale
        I18n.available_locales.each do |available_locale|
          define_method "#{attr_name}_#{available_locale.to_s.underscore}" do
            begin
              old_locale = I18n.locale
              I18n.locale = available_locale
              __send__(attr_name)
            ensure
              I18n.locale = old_locale
            end
          end
        end

        # Define setters for each specific available locale
        I18n.available_locales.each do |available_locale|
          define_method "#{attr_name}_#{available_locale.to_s.underscore}=" do |value|
            begin
              old_locale = I18n.locale
              I18n.locale = available_locale
              __send__(:"#{attr_name}=", value)
            ensure
              I18n.locale = old_locale
            end
          end
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
