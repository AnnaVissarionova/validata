
require 'validata/custom_validators/phone_number_validator'

RSpec.describe Validata::CustomValidators::PhoneNumberValidator do
  let(:validator) { described_class.new('TestValidator', min_length: 15, patterns: [/^\+\d{1,3}-\d{3}-\d{3}-\d{4}$/],
   country_code_pattern: /^\+(\d{1,3})/, region_code_pattern: /^\+\d{1,3}-(\d{3})/) }

  describe '.valid?' do
    context 'when phone number is valid' do
      it 'returns true' do
        expect(validator.valid?('+1-123-456-7890')).to be(true)
      end
    end

    context 'when phone number is invalid' do
      it 'returns false for invalid format' do
        expect(validator.valid?('+11234567890')).to be(false)
      end

      it 'returns false for too short phone number' do
        expect(validator.valid?('1-123-456-789')).to be(false)
      end

      it 'returns false for too long phone number' do
        long_phone = '+1-123-456-789000000'
        expect(validator.valid?(long_phone)).to be(false)
      end

      it 'returns false for blocked country code' do
        validator.block_country_code('1')
        expect(validator.valid?('+1-123-456-7890')).to be(false)
      end

      it 'returns false for blocked region' do
        validator.block_region('456')
        expect(validator.valid?('+1-456-456-7890')).to be(false)
      end

    end
  end

  describe '.validate_format' do
    it 'returns true for valid format' do
      expect(validator.send(:validate_format, '+1-123-456-7890')).to be(true)
    end

    it 'returns false for invalid format' do
      expect(validator.send(:validate_format, '+11234567890')).to be(false)
    end
  end

  describe '.validate_length' do
    it 'returns true for valid length' do
      expect(validator.send(:validate_length, '+1-123-456-7890')).to be(true)
    end

    it 'returns false for too short phone number' do
      expect(validator.send(:validate_length, '+1-123-456-7')).to be(false)
    end

    it 'returns false for too long phone number' do
      long_phone = '++1-123-456-78900'
      expect(validator.send(:validate_length, long_phone)).to be(false)
    end
  end

  describe '.validate_allowed_country_codes' do
    it 'returns true if allowed_country_codes is empty' do
      expect(validator.send(:validate_allowed_country_codes, '+1-123-456-7890')).to be(true)
    end

    it 'returns true for allowed country code' do
      validator.allow_country_code('123')
      expect(validator.send(:validate_allowed_country_codes, '+123-123-456-7890')).to be(true)
    end
  end

  describe '.validate_blocked_country_codes' do
    it 'returns true if blocked_country_codes is empty' do
      expect(validator.send(:validate_blocked_country_codes, '+1-123-456-7890')).to be(true)
    end

    it 'returns false for blocked country code' do
      validator.block_country_code('345')
      expect(validator.send(:validate_blocked_country_codes, '+345-123-456-7890')).to be(false)
    end

    it 'returns true for not blocked country code' do
      validator.block_country_code('345')
      expect(validator.send(:validate_blocked_country_codes, '+1-123-456-7890')).to be(true)
    end
  end

  describe '.validate_allowed_regions' do
    it 'returns true if allowed_regions is empty' do
      expect(validator.send(:validate_allowed_regions, '+1-123-456-7890')).to be(true)
    end

    it 'returns true for allowed region' do
      validator.allow_region('123')
      expect(validator.send(:validate_allowed_regions, '+1-123-456-7890')).to be(true)
    end
  end

  describe '.validate_blocked_regions' do
    it 'returns true if blocked_regions is empty' do
      expect(validator.send(:validate_blocked_regions, '+1-123-456-7890')).to be(true)
    end

    it 'returns false for blocked region' do
      validator.block_region('123')
      expect(validator.send(:validate_blocked_regions, '+1-123-456-7890')).to be(false)
    end

  end

  describe '.validate_internal_codes' do
    it 'returns true if internal_codes is empty' do
      expect(validator.send(:validate_internal_codes, '+1-123-456-7890')).to be(true)
    end

    it 'returns true if contains internal code' do
      validator.add_internal_code('456')
      expect(validator.send(:validate_internal_codes, '+1-123-456-7890')).to be(true)
    end

  end

  describe '.extract_country_code' do
    it 'returns the country code' do
      expect(validator.send(:extract_country_code, '+1-123-456-7890')).to eq('1')
    end
  end

  describe '.extract_region_code' do
    it 'returns the region code' do
      expect(validator.send(:extract_region_code, '+1-123-456-7890')).to eq('123')
    end

    it 'returns nil if no region code' do
      expect(validator.send(:extract_region_code, '+1--123-7890')).to be_nil
    end
  end
end
