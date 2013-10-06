require 'spec_helper'

describe SerialTranslator do

  let(:object) { FakeObject.new }

  describe 'getting a translated value' do
    it 'returns the translated value in the requested locale' do
      object.title_translations = { de: 'German translation', en: 'English translation' }
      object.title(:de).should eq 'German translation'
    end

    it 'returns the origin locale value if no translation is present' do
      object.title_translations = { en: 'English translation' }
      object.title(:de).should eq 'English translation'
    end

    it 'returns the origin locale value if the translation is empty' do
      object.title_translations = { de: '', en: 'English translation' }
      object.title(:de).should eq 'English translation'
    end

    it 'returns nil if no translations are there at all' do
      object.title_translations = {}
      object.title(:de).should be_nil
    end

    it 'uses the given text locale' do
      object.title_translations = { de: 'Deutsch', en: 'English' }
      object.current_translation_locale = :en
      object.title.should eq 'English'
    end

    it 'does not fail even if translations were not initialized before' do
      object.title.should be_blank
    end
  end

  describe 'writing an attribute' do
    it 'sets the value for the current text locale' do
      object.current_translation_locale = :de
      object.title = 'Deutsch'
      object.title_translations.should eq({ de: 'Deutsch' })
    end
  end

  describe '#current_translation_locale' do
    it 'returns the value that was given' do
      object.current_translation_locale = 'de'
      object.current_translation_locale.should eq :de
    end

    it 'must not return nil' do
      object.current_translation_locale = nil
      object.current_translation_locale.should eq I18n.locale.to_sym
    end
  end

  describe '#translated_locales' do
    it 'returns an empty array if nothing was translated' do
      object.translated_locales.should eq []
    end

    it 'includes all locales where something is present' do
      object.title_translations = { en: 'Foo', de: 'Foo' }
      object.summary_translations = { nb: 'Foo' }
      object.translated_locales.should eq [:en, :de, :nb]
    end

    it 'does not include locales where all translations are blank' do
      object.title_translations = { en: 'Foo', de: '' }
      object.translated_locales.should eq [:en]
    end
  end
end
