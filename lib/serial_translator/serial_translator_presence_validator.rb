class SerialTranslator::SerialTranslatorPresenceValidator < ActiveModel::Validations::PresenceValidator
  def validate_each(record, attribute, _value)
    translations = record.__send__("#{attribute}_translations") || {}
    return if translations.values.any?(&:present?)
    record.errors.add_on_blank(attribute, options)
  end

  def kind; :presence end
end
