# frozen_string_literal: true

RSpec.describe Amka do
  it 'has a version number' do
    expect(Amka::VERSION).not_to be_nil
  end

  describe '.generate' do
    it 'generates valid AMKAs' do
      100.times do
        amka = described_class.generate

        # length must equal 11
        expect(amka.length).to eq(11)

        # first 6 digits must be a valid date
        expect { Date.strptime(amka[0..5], '%d%m%y') }.not_to raise_error

        # make sure the amka is valid according to the Luhn algorithm
        expect(Amka::Luhn.valid?(amka)).to be true
      end
    end
  end

  describe '.valid?' do
    it 'rejects AMKAs with invalid dates but valid Luhn' do
      luhn_valid_ids = %w[97909369536 72021984173 10133701093 10185628285]

      # first assert that ids are valid according to Luhn algorithm
      valid_luhns = luhn_valid_ids.select { |id| Amka::Luhn.valid?(id) }
      expect(valid_luhns.length).to eq(4)

      # then assert that these ids are not valid AMKAs
      valid_amka = luhn_valid_ids.select { |id| described_class.valid?(id) }
      expect(valid_amka.length).to eq(0)

      # and they are not valid because date is invalid
      luhn_valid_ids.each do |id|
        expect { Date.strptime(id[0..5], '%d%m%y') }.to raise_error(ArgumentError, 'invalid date')
      end

      # And to prove that invalid date caused the AMKAs not to be valid,
      # let's mock the Utils.valid_date? method to return true
      allow(Amka::Utils).to receive(:valid_date?).and_return(true)
      false_positive_valid_amka = luhn_valid_ids.select { |id| described_class.valid?(id) }
      expect(false_positive_valid_amka.length).to eq(4)
    end

    it 'rejects AMKAs with valid dates but invalid Luhn' do
      date_valid_ids = %w[11118734597 02039936475 20127837465 09080237485]

      # first assert that dates are valid
      date_valid = date_valid_ids.select do |id|
        Date.strptime(id[0..5], '%d%m%y')
        true
      rescue ArgumentError
        false
      end
      expect(date_valid.length).to eq(4)

      # then assert that these ids are not valid amka
      valid_amka = date_valid_ids.select { |id| described_class.valid?(id) }
      expect(valid_amka.length).to eq(0)

      # and they are not valid because they fail the Luhn algorithm
      valid_luhn = date_valid_ids.select { |id| Amka::Luhn.valid?(id) }
      expect(valid_luhn.length).to eq(0)

      # and to prove the above assertion let's mock the Luhn.valid? method
      allow(Amka::Luhn).to receive(:valid?).and_return(true)
      false_positive_valid_amka = date_valid_ids.select { |id| described_class.valid?(id) }
      expect(false_positive_valid_amka.length).to eq(4)
    end

    it 'rejects AMKAs with valid date, valid Luhn but wrong length' do
      wrong_length_ids = %w[1111897 020498861 0911045466 170567716585]

      # first assert that dates are valid
      date_valid = wrong_length_ids.select do |id|
        Date.strptime(id[0..5], '%d%m%y')
        true
      rescue ArgumentError
        false
      end
      expect(date_valid.length).to eq(4)

      # then assert that ids are valid according to Luhn algorithm
      valid_luhns = wrong_length_ids.select { |id| Amka::Luhn.valid?(id) }
      expect(valid_luhns.length).to eq(4)

      # then assert that these ids are not valid amka
      valid_amka = wrong_length_ids.select { |id| described_class.valid?(id) }
      expect(valid_amka.length).to eq(0)

      # and to prove the above assertion let's mock the private length_is_11? method
      allow(described_class).to receive(:length_is_11?).and_return(true)
      false_positive_valid_amka = wrong_length_ids.select { |id| described_class.valid?(id) }
      expect(false_positive_valid_amka.length).to eq(4)
    end
  end
end
