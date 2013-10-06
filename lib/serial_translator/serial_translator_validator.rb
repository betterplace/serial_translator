class SerialTranslator::SerialTranslatorValidator < ActiveModel::EachValidator

  # SimpleForm inspects validators to find out how long
  # a field may be.
  def kind
    options[:length].present? ? :length : :presence
  end

  # SimpleForm expects the options :maximum and :minimum to be present
  # for length validations. This is why we inspect our range and set them
  # if possible.
  def initialize(options)
    if length = options[:length]
      length.is_a?(Range) or raise "Only range values are allowed for length"
      options[:maximum] = length.max
      options[:minimum] = length.min
    end
    super options
  end

  def validate_each(record, attribute, value)
    options[:presence] and validate_presence(record, attribute)
    options[:length]   and validate_translation_lengths(record, attribute)
  end

  def validate_presence(record, attribute)
    translations = record.__send__(:"#{attribute}_translations") || {}
    translations.values.any?(&:present?) or record.errors.add_on_blank(attribute, options)
  end

  def validate_translation_lengths(record, attribute)
    translations = record.__send__(:"#{attribute}_translations") || {}

    translations.each do |locale, value|
      validate_length(record, attribute, value)
    end
  end

  def validate_length(record, attribute, value)
    return if value.blank?
    length = options[:length]

    value_length = value.respond_to?(:length) ? value.length : value.to_s.length

    value_length < length.min and record.errors.add(attribute, :too_short, count: length.min)
    value_length > length.max and record.errors.add(attribute, :too_long, count: length.max)
  end
end
