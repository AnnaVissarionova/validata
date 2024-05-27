
require 'resolv'
require 'validata/custom_validators/email_validator'

RSpec.describe Validata::CustomValidators::EmailValidator do
  let(:default_pattern) { /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  let(:validator) { described_class.new('TestValidator') }

  describe '.valid?' do
    context 'when email is valid' do
      it 'returns true' do
        expect(validator.valid?('test@example.com')).to be true
      end
    end

    context 'when email is invalid' do
      it 'returns false for invalid format' do
        expect(validator.valid?('invalid_email')).to be false
      end

      it 'returns false for too short email' do
        expect(validator.valid?('a@b.c')).to be false
      end

      it 'returns false for too long email' do
        long_email = 'a' * 255 + '@example.com'
        expect(validator.valid?(long_email)).to be false
      end

      it 'returns false for blocked domain' do
        validator_with_blocked_domain = described_class.new('TestValidator', blocked_domains: ['blocked.com'])
        expect(validator_with_blocked_domain.valid?('test@blocked.com')).to be false
      end

      it 'returns false for not allowed domain' do
        validator_with_allowed_domain = described_class.new('TestValidator', allowed_domains: ['allowed.com'])
        expect(validator_with_allowed_domain.valid?('test@notallowed.com')).to be false
      end

      it 'returns false for non-existent MX records' do
        allow(validator).to receive(:mx_records_exist?).and_return false
        expect(validator.valid?('test@example.com')).to be false
      end
    end
  end

  describe '.validate_format' do
    it 'returns true for valid email format' do
      expect(validator.send(:validate_format, 'test@example.com')).to be true
    end

    it 'returns false for invalid email format' do
      expect(validator.send(:validate_format, 'invalid_email')).to be false
    end
  end

  describe '.validate_length' do
    it 'returns true for valid length' do
      expect(validator.send(:validate_length, 'test@example.com')).to be true
    end

    it 'returns false for too short email' do
      short_email_validator = described_class.new('TestValidator', min_length: 6)
      expect(short_email_validator.valid?('a@b.c')).to be false
    end

    it 'returns false for too long email' do
      long_email = 'a' * 255 + '@example.com'
      expect(validator.send(:validate_length, long_email)).to be false
    end
  end

  describe '.validate_allowed_domains' do
    it 'returns true if allowed_domains is empty' do
      expect(validator.send(:validate_allowed_domains, 'test@example.com')).to be true
    end

    it 'returns true for allowed domain' do
      validator_with_allowed_domain = described_class.new('TestValidator', allowed_domains: ['allowed.com'])
      expect(validator_with_allowed_domain.send(:validate_allowed_domains, 'test@allowed.com')).to be true
    end

    it 'returns false for not allowed domain' do
      validator_with_allowed_domain = described_class.new('TestValidator', allowed_domains: ['allowed.com'])
      expect(validator_with_allowed_domain.send(:validate_allowed_domains, 'test@notallowed.com')).to be false
    end
  end

  describe '.validate_blocked_domains' do
    it 'returns true if domain is not blocked' do
      expect(validator.send(:validate_blocked_domains, 'test@example.com')).to be true
    end

    it 'returns false if domain is blocked' do
      validator_with_blocked_domain = described_class.new('TestValidator', blocked_domains: ['blocked.com'])
      expect(validator_with_blocked_domain.send(:validate_blocked_domains, 'test@blocked.com')).to be false
    end
  end

  describe '.validate_mx_records' do
    it 'returns true if MX records exist' do
      allow(validator).to receive(:mx_records_exist?).and_return true
      expect(validator.send(:validate_mx_records, 'test@example.com')).to be true
    end

    it 'returns false if MX records do not exist' do
      allow(validator).to receive(:mx_records_exist?).and_return false
      expect(validator.send(:validate_mx_records, 'test@example.com')).to be false
    end
  end

  describe '.mx_records_exist?' do
    it 'returns true if MX records exist for the domain' do
      allow(Resolv::DNS).to receive(:open).and_yield(double(getresources: [double]))
      expect(validator.send(:mx_records_exist?, 'example.com')).to be true
    end

    it 'returns false if MX records do not exist for the domain' do
      allow(Resolv::DNS).to receive(:open).and_yield(double(getresources: []))
      expect(validator.send(:mx_records_exist?, 'example.com')).to be false
    end
  end
end
