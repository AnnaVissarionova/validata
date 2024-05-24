require 'resolv'
require 'uri'
require 'validata/uri_validation'

RSpec.describe Validata::URIValidation do

  describe '.valid?' do
    it 'returns true for a valid URL with HTTP scheme' do
      expect(described_class.valid?('http://example.com')).to be true
    end

    it 'returns true for a valid URL with HTTPS scheme' do
      expect(described_class.valid?('https://example.com')).to be true
    end

    it 'returns false for an invalid URL' do
      expect(described_class.valid?('invalidurl')).to be false
    end
  end

  describe '.validation_comment' do
    it 'returns "Valid URL" for a valid URL' do
      expect(described_class.validation_comment('http://example.com')).to eq('Valid URL')
    end

    it 'returns message for an invalid URL with invalid scheme' do
      expect(described_class.validation_comment('inv://example.com')).to eq('Invalid scheme')
    end

    it 'returns message for an invalid URL with empty hier-part' do
      expect(described_class.validation_comment('http://')).to eq('Empty or invalid hier-part')
    end

    it 'returns message for an invalid URL with non-existent domain' do
      expect(described_class.validation_comment('http://nonexistentdomain.com')).to eq("Domain doesn't exist")
    end
  end

  describe 'private methods' do
    describe '.valid_scheme?' do
      it 'returns true for a valid scheme' do
        expect(described_class.send(:valid_scheme?, URI.parse('http://example.com'))).to be true
      end

      it 'returns false for an invalid scheme' do
        expect(described_class.send(:valid_scheme?, URI.parse('ftp://example.com'))).to be true
      end
    end

    describe '.valid_hier_part?' do
      it 'returns true for a valid hier-part' do
        expect(described_class.send(:valid_hier_part?, URI.parse('http://example.com'))).to be true
      end

      it 'returns false for an empty hier-part' do
        expect(described_class.send(:valid_hier_part?, URI.parse('http://'))).to be false
      end
    end

    describe '.domain_exists?' do
      it 'returns true for an existing domain' do
        expect(described_class.send(:domain_exists?, 'example.com')).to be true
      end

      it 'returns false for a non-existing domain' do
        expect(described_class.send(:domain_exists?, 'nonexistentdomain111.com')).to be false
      end
    end
  end
end
