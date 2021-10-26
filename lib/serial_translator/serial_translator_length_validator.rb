module SerialTranslator
  class SerialTranslatorLengthValidator < ActiveModel::Validations::LengthValidator
    def validate_each(record, attribute, _value)
      translations = record.__send__("#{attribute}_translations")&.values || []
      translations = [nil] if translations.empty?
      translations.each do |value|
        next if (options[:allow_blank] && value.to_s == '') ||
                (options[:allow_nil]   && value.nil?)

        validate_translation(record, attribute, value)
      end
    end

    # this is ActiveModel::Validations::LengthValidator#validate_each,
    # only extended with more interpolation args in error_options
    def validate_translation(record, attribute, value)
      value_length = value.respond_to?(:length) ? value.length : value.to_s.length
      error_options = options.except(*RESERVED_OPTIONS)

      CHECKS.each do |key, validity_check|
        next unless check_value = options[key]

        if !value.nil? || skip_nil_check?(key)
          next if value_length.send(validity_check, check_value)
        end

        error_options.merge!(count: check_value, actual_length: value_length)
        key == :minimum && error_options[:difference] = check_value - value_length
        key == :maximum && error_options[:difference] = value_length - check_value

        default_message = options[MESSAGES[key]]
        error_options[:message] ||= default_message if default_message
        record.errors.add(attribute, MESSAGES[key], **error_options)
      end
    end

    def kind; :length end
  end
end
