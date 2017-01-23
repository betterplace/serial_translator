require 'spec_helper'

describe SerialTranslator::SerialTranslatorLengthValidator do
  let(:example) { Fake.new }

  describe 'validation' do
    it 'validates min length correctly' do
      example.title = '123'
      expect(example).to have(1).error_on(:title)
    end

    it 'validates max length correctly' do
      example.title = 'f' * 26
      expect(example).to have(1).error_on(:title)
    end

    it 'validates correctly if only a minimum is given' do
      example.credits = 'f' * 99
      expect(example).to have(1).error_on(:credits)
      example.credits = 'f' * 100
      expect(example).to have(:no).errors_on(:credits)
    end

    it 'validates correctly if only a maximum is given' do
      example.imprint = 'f' * 101
      expect(example).to have(1).error_on(:imprint)
      example.imprint = 'f' * 100
      expect(example).to have(:no).errors_on(:imprint)
    end

    it 'validates correctly if a specific value is given' do
      example.subtitle = 'f' * 8
      expect(example).to have(1).error_on(:subtitle)
      example.subtitle = 'f' * 9
      expect(example).to have(:no).errors_on(:subtitle)
      example.subtitle = 'f' * 10
      expect(example).to have(1).error_on(:subtitle)
    end

    it 'validates all translation values' do
      example.title_translations = { en: '123', de: '123' }
      expect(example).to have(2).errors_on(:title)

      example.title_translations = { en: '123456', de: '123' }
      expect(example).to have(1).error_on(:title)

      example.title_translations = { en: '123', de: '123456' }
      expect(example).to have(1).error_on(:title)

      example.title_translations = { en: '123456', de: '123456' }
      expect(example).to have(:no).errors_on(:title)
    end

    it 'validates correctly on language change as well' do
      I18n.locale = :de
      example.title = 'Valid foo'
      expect(example).to have(:no).errors_on(:title)

      I18n.locale = :en
      example.title = ''
      expect(example).to have(:no).errors_on(:title)
    end

    it 'ignores blank fields if allow_blank is true' do
      example.summary_translations = { de: '' }
      expect(example).to have(:no).errors_on(:summary)
    end

    it 'ignores blank fields if only a maximum is given' do
      example.credits_translations = { de: '' }
      expect(example).to have(:no).errors_on(:imprint)
    end

    it 'does not ignore blank fields otherwise' do
      example.title_translations = { de: '' }
      expect(example).to have(1).error_on(:title)
    end

    it 'ignores nil if allow_nil is true' do
      example.subtitle_translations = { de: nil }
      expect(example).to have(:no).errors_on(:subtitle)
    end

    it 'ignores nil if only a maximum is given' do
      example.credits_translations = { de: nil }
      expect(example).to have(:no).errors_on(:imprint)
    end

    it 'does not ignore nil otherwise' do
      example.title_translations = { de: nil }
      expect(example).to have(1).error_on(:title)
    end
  end

  it 'is of kind "length"' do
    expect(described_class.new(attributes: %i(foo), in: 1..2).kind)
      .to eq :length
  end
end
