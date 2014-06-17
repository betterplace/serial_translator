require 'spec_helper'

describe SerialTranslator::SerialTranslatorValidator do
  let(:example) { FakeObject.new }

  describe 'presence validation' do
    it 'validates presence correctly if attribute is nil' do
      example.valid?
      example.errors[:description].size.should eq 1
    end

    it 'validates presence correctly if attribute is empty' do
      example.description = ''
      example.valid?
      example.errors[:description].size.should eq 1
    end

    it 'has no error if everything is fine' do
      example.description = 'This is a nice foo thing'
      example.valid?
      example.errors[:description].size.should eq 0
    end

    it 'is valid if any language has a value' do
      example.description_translations = { en: '', de: '' }
      example.valid?
      example.errors[:description].size.should eq 1

      example.description_translations = { en: '', de: 'foobar' }
      example.valid?
      example.errors[:description].size.should eq 0

      example.description_translations = { en: 'foobar', de: nil }
      example.valid?
      example.errors[:description].size.should eq 0
    end
  end

  describe 'length validation' do
    it 'validates min length correctly' do
      example.title = '123'
      example.valid?
      example.errors[:title].size.should eq 1
    end

    it 'validates max length correctly' do
      example.title = 'f' * 26
      example.valid?
      example.errors[:title].size.should eq 1
    end

    it 'ignores blank fields' do
      example.title = ''
      example.valid?
      example.errors[:title].size.should eq 0
    end

    it 'validates all translation values' do
      example.title_translations = { en: '123', de: '123' }
      example.valid?
      example.errors[:title].size.should eq 2

      example.title_translations = { en: '123456', de: '123' }
      example.valid?
      example.errors[:title].size.should eq 1

      example.title_translations = { en: '123', de: '123456' }
      example.valid?
      example.errors[:title].size.should eq 1

      example.title_translations = { en: '123456', de: '123456' }
      example.valid?
      example.errors[:title].size.should eq 0
    end

    it 'validates correctly on language change as well' do
      I18n.locale = :de
      example.description = :something_to_make_it_pass_valid
      example.title = 'Valid foo'
      example.should be_valid

      I18n.locale = :en
      example.title = ''
      example.should be_valid
    end
  end

  describe '#kind' do
    it 'returns length if length validation is set' do
      validator = SerialTranslator::SerialTranslatorValidator.new(attributes: :foo, length: 1..2)
      validator.kind.should eq :length
    end

    it 'returns presence if it is no length validation' do
      validator = SerialTranslator::SerialTranslatorValidator.new(attributes: :foo)
      validator.kind.should eq :presence
    end
  end
end

