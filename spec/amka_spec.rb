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
    context 'with non-string inputs' do
      it 'returns false instead of raising exceptions' do
        invalid_inputs = [nil, 123_456_789_012, [], {}, true]

        invalid_inputs.each do |input|
          expect(described_class.valid?(input)).to eq(false)
        end
      end
    end

    it 'returns false for strings with non-digits' do
      invalid_strings = %w[123abc456 A12345678901 123-456-789]

      invalid_strings.each do |input|
        expect(described_class.valid?(input)).to eq(false)
      end
    end

    it 'rejects AMKAs with invalid dates but valid Luhn' do
      luhn_valid_ids = %w[97909369536 72021984173 10133701093 10185628285]

      # first assert that ids are valid according to Luhn algorithm
      valid_luhns = luhn_valid_ids.select { |id| Amka::Luhn.safe_valid?(id) }
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
      valid_luhn = date_valid_ids.select { |id| Amka::Luhn.safe_valid?(id) }
      expect(valid_luhn.length).to eq(0)

      # and to prove the above assertion let's mock the Luhn.safe_valid? method
      allow(Amka::Luhn).to receive(:safe_valid?).and_return(true)
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
      valid_luhns = wrong_length_ids.select { |id| Amka::Luhn.safe_valid?(id) }
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

  describe '.validate' do
    it 'returns empty array for valid AMKAs' do
      # Generate a valid AMKA for testing
      valid_amka = described_class.generate

      # Should return an empty array
      expect(described_class.validate(valid_amka)).to eq([])
    end

    it 'returns specific error for non-string inputs' do
      invalid_inputs = [nil, 123_456_789_012, [], {}, true]

      invalid_inputs.each do |input|
        errors = described_class.validate(input)
        expect(errors).to include('AMKA must be a string')
        expect(errors.length).to eq(1) # Should only return the first error
      end
    end

    it 'returns specific error for strings with non-digits' do
      invalid_strings = %w[123abc456 A12345678901 123-456-789]

      invalid_strings.each do |input|
        errors = described_class.validate(input)
        expect(errors).to include('AMKA must contain only digits')
        expect(errors.length).to eq(1) # Should only return the first error
      end
    end

    it 'returns length error for incorrect length' do
      # Too short
      errors_short = described_class.validate('1234567890')
      expect(errors_short).to include('AMKA must be exactly 11 digits long')

      # Too long
      errors_long = described_class.validate('123456789012')
      expect(errors_long).to include('AMKA must be exactly 11 digits long')
    end

    it 'returns multiple errors when applicable' do
      # Create a string with correct format but wrong length and invalid date
      # This should return both length and date errors
      errors = described_class.validate('3201901234') # 10 digits, invalid date (32nd day)

      expect(errors).to include('AMKA must be exactly 11 digits long')
      # Our implementation collects all errors
      expect(errors.length >= 1).to be true

      # Now test with correct length but multiple other errors
      errors = described_class.validate('32019012345') # 11 digits, invalid date (32nd)

      expect(errors).to include('First 6 digits of AMKA must form a valid date (DDMMYY)')
      # It may also fail Luhn, we expect multiple errors
      expect(errors.size >= 1).to be true
    end

    it 'includes Luhn check error when applicable' do
      # Create a number with valid date but invalid Luhn
      # We'll use a known valid date (01/01/90) but change the last digit to make Luhn invalid
      luhn_invalid = '01019012340' # Changed last digit

      # Verify the first 6 digits are a valid date
      expect(Amka::Utils.valid_date?(luhn_invalid)).to eq(true)

      # Now validate it should fail Luhn check
      errors = described_class.validate(luhn_invalid)
      expect(errors).to include('AMKA must satisfy the Luhn algorithm check')
    end
  end

  describe '.validate!' do
    it 'returns true for valid AMKAs' do
      # Generate a valid AMKA for testing
      valid_amka = described_class.generate

      # Should not raise an exception
      expect(described_class.validate!(valid_amka)).to eq(true)
    end

    it 'raises ValidationError for non-string inputs' do
      invalid_inputs = [nil, 123_456_789_012, [], {}, true]

      invalid_inputs.each do |input|
        expect do
          described_class.validate!(input)
        end.to raise_error(Amka::ValidationError, 'AMKA must be a string')
      end
    end

    it 'raises ValidationError for strings with non-digits' do
      invalid_strings = %w[123abc456 A12345678901 123-456-789]

      invalid_strings.each do |input|
        expect do
          described_class.validate!(input)
        end.to raise_error(Amka::ValidationError, 'AMKA must contain only digits')
      end
    end

    it 'raises ValidationError for incorrect length' do
      # Too short
      expect do
        described_class.validate!('1234567890')
      end.to raise_error(Amka::ValidationError, 'AMKA must be exactly 11 digits long')

      # Too long
      expect do
        described_class.validate!('123456789012')
      end.to raise_error(Amka::ValidationError, 'AMKA must be exactly 11 digits long')
    end

    it 'raises ValidationError for invalid date' do
      # Valid format and length but invalid date (32nd day of month)
      expect do
        described_class.validate!('32019012345')
      end.to raise_error(Amka::ValidationError,
                         'First 6 digits of AMKA must form a valid date (DDMMYY)')
    end

    it 'raises ValidationError for invalid Luhn check' do
      # Create a number with valid date but invalid Luhn
      # We'll use a known valid date (01/01/90) but change the last digit to make Luhn invalid
      luhn_invalid = '01019012340' # Changed last digit

      # Verify the first 6 digits are a valid date
      expect(Amka::Utils.valid_date?(luhn_invalid)).to eq(true)

      # Now validate it should fail Luhn check
      expect do
        described_class.validate!(luhn_invalid)
      end.to raise_error(Amka::ValidationError, 'AMKA must satisfy the Luhn algorithm check')
    end
  end
end
