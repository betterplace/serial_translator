class SerialTranslator::TranslationType < ActiveRecord::Type::String
  def cast(value)
    case value
    when nil
      {}
    when Hash
      value
    when /\A---/
      YAML.load(value)
    else
      JSON.parse(value).symbolize_keys
    end
  end

  def serialize(value)
    case value
    when String
      super
    else
      JSON(value)
    end
  end
end
