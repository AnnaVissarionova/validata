require 'validata/email_validation'
require 'resolv'

RSpec.describe Validata::EmailValidation do
  describe '.valid?' do
    context 'with valid email addresses' do
      it 'returns true for a simple valid email' do
        expect(described_class.valid?('test@example.com')).to be true
      end

      it 'returns true for an email with dash in the domain' do
        expect(described_class.valid?('test@example-domain.com')).to be true
      end

      it 'returns true for an email with nums in the domain' do
        expect(described_class.valid?('test@123example.com')).to be true
      end
    end

    context 'with invalid email addresses' do
      it 'returns false for an email without @ symbol' do
        expect(described_class.valid?('test.example.com')).to be false
      end

      it 'returns false for an email with invalid domain' do
        expect(described_class.valid?('test@invalid_domain')).to be false
      end

      it 'returns false for an email with multiple @ symbols' do
        expect(described_class.valid?('test@@example.com')).to be false
      end

      it 'returns false for an email with invalid third-level-domain' do
        expect(described_class.valid?('test@example.invalid')).to be false
      end

      it 'returns false for an email with missing local part' do
        expect(described_class.valid?('@example.com')).to be false
      end
    end
  end

  describe '.valid_domain?' do
    let(:domain) { 'example.com' }

    it 'returns true if MX records exist for the domain' do
      expect(described_class.send(:valid_domain?, domain)).to be true
    end

    it 'returns true if A records exist for the domain' do
      expect(described_class.send(:valid_domain?, domain)).to be true
    end

    it 'returns false if no MX or A records exist for the domain' do
      non_existent_domain = 'nonexistentdomain.abc'
      expect(described_class.send(:valid_domain?, non_existent_domain)).to be false
    end
  end

  describe '.mx_records_exist?' do
    it 'returns true if MX records exist' do
      expect(described_class.send(:mx_records_exist?, 'example.com')).to be true
    end

    it 'returns false if MX records do not exist' do
      expect(described_class.send(:mx_records_exist?, 'nonexistentdomain.abc')).to be false
    end
  end

  describe '.a_record_exists?' do
    it 'returns true if A records exist' do
      expect(described_class.send(:a_record_exists?, 'example.com')).to be true
    end

    it 'returns false if A records do not exist' do
      expect(described_class.send(:a_record_exists?, 'nonexistentdomain.abc')).to be false
    end
  end
end
