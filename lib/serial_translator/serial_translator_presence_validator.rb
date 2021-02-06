module SerialTranslator
  class SerialTranslatorPresenceValidator < ActiveModel::Validations::PresenceValidator
    def validate_each(record, attribute, _value)
      translations = record.__send__("#{attribute}_translations") || {}
      return if translations.values.any?(&:present?)
      if record.send(attribute).blank?
        record.errors.add(attribute, :blank, **options)
      end
    end

    def kind
      :presence
    end
  end
end
