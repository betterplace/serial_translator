require 'spec_helper'

describe SerialTranslator do

  let(:object) { FakeObject.new }

  describe 'getting a translated value' do
    it 'returns the translated value in the requested locale' do
      object.title_translations = { de: 'German translation', en: 'English translation' }
      expect(object.title(:de)).to eq 'German translation'
    end

    it 'provides a boolean predicate to check the presence of a translated value' do
      expect(object.title?(:de)).to eq false
      object.title_translations = { de: 'German translation', en: 'English translation' }
      expect(object.title?(:de)).to eq true
    end

    it 'returns the origin locale value if no translation is present' do
      object.title_translations = { en: 'English translation' }
      expect(object.title(:de)).to eq 'English translation'
    end

    it 'returns the origin locale value if the translation is empty' do
      object.title_translations = { de: '', en: 'English translation' }
      expect(object.title(:de)).to eq 'English translation'
    end

    it 'returns nil if no translations are there at all' do
      object.title_translations = {}
      expect(object.title(:de)).to be_nil
    end

    it 'uses the given text locale' do
      object.title_translations = { de: 'Deutsch', en: 'English' }
      object.current_translation_locale = :en
      expect(object.title).to eq 'English'
    end

    it 'does not fail even if translations were not initialized before' do
      expect(object.title).to be_blank
    end
  end

  describe 'writing an attribute' do
    it 'sets the value for the current text locale' do
      object.current_translation_locale = :de
      object.title = 'Deutsch'
      expect(object.title_translations).to eq({ de: 'Deutsch' })
    end

    it 'nil removes the value for the current text locale' do
      object.title_translations = { de: 'Deutsch' }
      object.current_translation_locale = :de
      object.title = nil
      expect(object.title_translations).to eq({})
    end

    it 'blank string removes the value for the current text locale' do
      object.title_translations = { de: 'Deutsch' }
      object.current_translation_locale = :de
      object.title = "    "
      expect(object.title_translations).to eq({})
    end

    it 'marks the changes on the object for active record' do
      object.title = 'Changed'
      expect(object.changes).to include :title_translations
    end
  end

  describe 'getting an attribute for a specific locale' do
    it 'gets the correct translation' do
      object.title_translations = { de: 'Deutsch' }
      expect(object.title_de).to eq 'Deutsch'
    end

    it 'uses fallback mechanisms as well' do
      object.title_translations = { en: 'English' }
      expect(object.title_de).to eq 'English'
    end
  end

  describe 'writing an attribute with for a specific locale' do
    it 'sets the value for the correct locale' do
      object.title_de = 'Deutsch'
      expect(object.title_translations).to eq({ de: 'Deutsch' })
    end

    it 'works for complex locales as well' do
      object.title_en_gb = 'Arrr'
      expect(object.title_translations).to eq({ :'en-GB' => 'Arrr' })
    end
  end

  describe '#current_translation_locale' do
    it 'returns the value that was given' do
      object.current_translation_locale = 'de'
      expect(object.current_translation_locale).to eq :de
    end

    it 'must not return nil' do
      object.current_translation_locale = nil
      expect(object.current_translation_locale).to eq I18n.locale.to_sym
    end
  end

  describe '#translated_locales' do
    it 'returns an empty array if nothing was translated' do
      expect(object.translated_locales).to eq []
    end

    it 'includes all locales where something is present' do
      object.title_translations = { en: 'Foo', de: 'Foo' }
      object.summary_translations = { nb: 'Foo' }
      expect(object.translated_locales).to eq [:en, :de, :nb]
    end

    it 'does not include locales where all translations are blank' do
      object.title_translations = { en: 'Foo', de: '' }
      expect(object.translated_locales).to eq [:en]
    end
  end

  describe '#translated_into?' do
    before { object.title_translations = { en: 'Foo', de: '' } }

    it 'returns true if there is a translation available for this locale' do
      expect(object).to be_translated_into :en
    end

    it 'returns false if there is no translation present for this locale' do
      expect(object).to_not be_translated_into :de
    end

    it 'returns false if this locale is unknown yet' do
      expect(object).to_not be_translated_into :yml
    end
  end
end
