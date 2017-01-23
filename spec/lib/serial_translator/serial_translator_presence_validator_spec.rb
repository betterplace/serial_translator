require 'spec_helper'

describe SerialTranslator::SerialTranslatorPresenceValidator do
  let(:example) { Fake.new }

  describe 'validation' do
    it 'validates presence correctly if attribute is nil' do
      example.description = nil
      expect(example).to have(1).error_on(:description)
    end

    it 'validates presence correctly if attribute is empty' do
      example.description = ''
      expect(example).to have(1).error_on(:description)
    end

    it 'has no error if everything is fine' do
      example.description = 'This is a nice foo thing'
      expect(example).to have(:no).errors_on(:description)
    end

    it 'is valid if any language has a value' do
      example.description_translations = { en: '', de: '' }
      expect(example).to have(1).error_on(:description)

      example.description_translations = { en: '', de: 'foobar' }
      expect(example).to have(:no).errors_on(:description)

      example.description_translations = { en: 'foobar', de: nil }
      expect(example).to have(:no).errors_on(:description)
    end
  end

  it 'is of kind "presence"' do
    expect(described_class.new(attributes: %i(foo)).kind)
      .to eq :presence
  end
end
