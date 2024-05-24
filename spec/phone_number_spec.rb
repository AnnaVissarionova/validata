require 'json'
require 'validata/phone_number_validation'

RSpec.describe Validata::PhoneNumberValidation do

  describe '.valid?' do
    it 'returns true for a valid phone number' do
      expect(described_class.valid?('+123456789')).to be true
    end

    it 'returns false for an invalid phone number' do
      expect(described_class.valid?('123456789')).to be false
    end
  end

  describe '.validation_comment' do
    it 'returns "Valid phone" for a valid phone number' do
      expect(described_class.validation_comment('+123456789')).to eq('Valid phone')
    end

    it 'returns message for an invalid phone number' do
      expect(described_class.validation_comment('invalid')).to eq('Invalid phone number. It contains non-numeric characters')
    end
  end

  describe 'private methods' do
    describe '.real_country_code?' do
      it 'returns true for a valid country code' do
        expect(described_class.send(:real_country_code?, '+123456789')).to be true
      end

      it 'returns false for an invalid country code' do
        expect(described_class.send(:real_country_code?, '+00023456789')).to be false
      end
    end
  end
end
