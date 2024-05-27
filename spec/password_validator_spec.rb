require 'validata/custom_validators/password_validator'

RSpec.describe Validata::CustomValidators::PasswordValidator do
  let(:validator) { described_class.new('TestValidator') }

  describe '.valid?' do
    context 'when password is valid' do
      it 'returns true' do
        expect(validator.valid?('Valid123!')).to be true
      end
    end

    context 'when password is invalid' do
      it 'returns false for too short password' do
        expect(validator.valid?('Short1!')).to be false
      end

      it 'returns false for too long password' do
        long_password = 'A' * 129 + '1!'
        expect(validator.valid?(long_password)).to be false
      end

      it 'returns false if missing uppercase letter' do
        validator_without_uppercase = described_class.new('TestValidator', require_uppercase: true)
        expect(validator_without_uppercase.valid?('valid123!')).to be false
      end

      it 'returns false if missing lowercase letter' do
        validator_without_lowercase = described_class.new('TestValidator', require_lowercase: true)
        expect(validator_without_lowercase.valid?('VALID123!')).to be false
      end

      it 'returns false if missing digit' do
        validator_without_digit = described_class.new('TestValidator', require_digit: true)
        expect(validator_without_digit.valid?('ValidPassword!')).to be false
      end

      it 'returns false if missing special character' do
        validator_without_special = described_class.new('TestValidator', require_special: true)
        expect(validator_without_special.valid?('Valid1234')).to be false
      end

      it 'returns false if contains blocked characters' do
        validator_with_blocked_chars = described_class.new('TestValidator', blocked_chars: ['!', '@'])
        expect(validator_with_blocked_chars.valid?('Valid123!')).to be false
      end
    end
  end

  describe '.validate_length' do
    it 'returns true for valid length' do
      expect(validator.send(:validate_length, 'Valid123!')).to be true
    end

    it 'returns false for too short password' do
      short_password_validator = described_class.new('TestValidator', min_length: 6)
      expect(short_password_validator.send(:validate_length, 'Short')).to be false
    end

    it 'returns false for too long password' do
      long_password = 'A' * 129 + '1!'
      expect(validator.send(:validate_length, long_password)).to be false
    end
  end

  describe '.validate_uppercase' do
    it 'returns true if uppercase is not required' do
      validator_without_uppercase = described_class.new('TestValidator', require_uppercase: false)
      expect(validator_without_uppercase.send(:validate_uppercase, 'valid123!')).to be true
    end

    it 'returns true if contains uppercase letter' do
      expect(validator.send(:validate_uppercase, 'Valid123!')).to be true
    end

    it 'returns false if missing uppercase letter' do
      expect(validator.send(:validate_uppercase, 'valid123!')).to be false
    end
  end

  describe '.validate_lowercase' do
    it 'returns true if lowercase is not required' do
      validator_without_lowercase = described_class.new('TestValidator', require_lowercase: false)
      expect(validator_without_lowercase.send(:validate_lowercase, 'VALID123!')).to be true
    end

    it 'returns true if contains lowercase letter' do
      expect(validator.send(:validate_lowercase, 'Valid123!')).to be true
    end

    it 'returns false if missing lowercase letter' do
      expect(validator.send(:validate_lowercase, 'VALID123!')).to be false
    end
  end

  describe '.validate_digit' do
    it 'returns true if digit is not required' do
      validator_without_digit = described_class.new('TestValidator', require_digit: false)
      expect(validator_without_digit.send(:validate_digit, 'ValidPassword!')).to be true
    end

    it 'returns true if contains digit' do
      expect(validator.send(:validate_digit, 'Valid123!')).to be true
    end

    it 'returns false if missing digit' do
      expect(validator.send(:validate_digit, 'ValidPassword!')).to be false
    end
  end

  describe '.validate_special' do
    it 'returns true if special character is not required' do
      validator_without_special = described_class.new('TestValidator', require_special: false)
      expect(validator_without_special.send(:validate_special, 'Valid1234')).to be true
    end

    it 'returns true if contains special character' do
      expect(validator.send(:validate_special, 'Valid123!')).to be true
    end

    it 'returns false if missing special character' do
      expect(validator.send(:validate_special, 'Valid1234')).to be false
    end
  end

  describe '.validate_blocked_chars' do
    it 'returns true if blocked_chars is empty' do
      expect(validator.send(:validate_blocked_chars, 'Valid123!')).to be true
    end

    it 'returns false if contains blocked characters' do
      validator_with_blocked_chars = described_class.new('TestValidator', blocked_chars: ['!', '@'])
      expect(validator_with_blocked_chars.send(:validate_blocked_chars, 'Valid123!')).to be false
    end

    it 'returns true if does not contain blocked characters' do
      validator_with_blocked_chars = described_class.new('TestValidator', blocked_chars: ['$', '%'])
      expect(validator_with_blocked_chars.send(:validate_blocked_chars, 'Valid123!')).to be true
    end
  end
end
