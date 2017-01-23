require 'spec_helper'

describe SerialTranslator::TranslationType do
  let(:type) { SerialTranslator::TranslationType.new }

  describe '#cast' do
    it 'works for JSON' do
      expect(type.cast('{"foo":"bar"}')).to eq('foo' => 'bar')
    end

    it 'works for YAML' do
      expect(type.cast("---\nfoo: bar")).to eq('foo' => 'bar')
    end

    it 'does nothing if already a Hash' do
      expect(type.cast({foo: :bar})).to eq(foo: :bar)
    end

    it 'defaults to empty hash' do
      expect(type.cast(nil)).to eq({})
    end
  end

  describe '#serialize' do
    it 'converts to JSON' do
      expect(type.serialize({foo: :bar})).to eq('{"foo":"bar"}')
    end

    it 'leaves strings alone (to avoid double serialization)' do
      expect(type.serialize('foo')).to eq 'foo'
    end
  end
end
