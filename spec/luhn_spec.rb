# frozen_string_literal: true

RSpec.describe Amka::Luhn do
  describe '.valid?' do
    it 'validates correct Luhn IDs' do
      valid_luhn_ids = %w[
        4532015112830366 79927398713 5361281695669 1234567897
      ]

      valid_luhn_ids.each do |id|
        expect(described_class.valid?(id)).to be true
      end
    end

    it 'rejects invalid Luhn IDs' do
      invalid_luhn_ids = %w[
        4532015112830367 79927398714 5361281695660 1234567896
      ]

      invalid_luhn_ids.each do |id|
        expect(described_class.valid?(id)).to be false
      end
    end

    it 'raises error for non-digit strings' do
      expect { described_class.valid?('123abc456') }.to raise_error(ArgumentError)
      expect { described_class.valid?('123-456-789') }.to raise_error(ArgumentError)
      expect { described_class.valid?('') }.to raise_error(ArgumentError)
    end

    it 'raises error for non-string inputs' do
      expect { described_class.valid?(12_345) }.to raise_error(ArgumentError)
      expect { described_class.valid?(nil) }.to raise_error(ArgumentError)
      expect { described_class.valid?([1, 2, 3, 4, 5]) }.to raise_error(ArgumentError)
    end
  end

  describe '.generate' do
    it 'generates valid Luhn IDs of specified length' do
      [10, 13, 16, 19].each do |length|
        id = described_class.generate(length)
        expect(id.length).to eq(length)
        expect(described_class.valid?(id)).to be true
      end
    end

    it 'generates valid Luhn IDs with a specified prefix' do
      prefix = '123456'
      id = described_class.generate(10, prefix)
      expect(id).to start_with(prefix)
      expect(id.length).to eq(10)
      expect(described_class.valid?(id)).to be true
    end

    it 'handles the special case of length 1' do
      id = described_class.generate(1)
      expect(id).to eq('0')
      expect(described_class.valid?(id)).to be true
    end

    it 'raises error when total is not greater than prefix length' do
      expect { described_class.generate(6, '123456') }.to raise_error(ArgumentError)
      expect { described_class.generate(5, '123456') }.to raise_error(ArgumentError)
    end

    it 'raises error for invalid total parameter' do
      expect { described_class.generate('10') }.to raise_error(ArgumentError)
      expect { described_class.generate(0) }.to raise_error(ArgumentError)
      expect { described_class.generate(-5) }.to raise_error(ArgumentError)
    end

    it 'raises error for invalid id_start parameter' do
      expect { described_class.generate(10, '123abc') }.to raise_error(ArgumentError)
      expect { described_class.generate(10, 123) }.to raise_error(ArgumentError)
      expect { described_class.generate(10, nil) }.to raise_error(ArgumentError)
    end
  end
end
