require 'resolv'
require 'uri'

module Validata
  module URIValidation
    VALID_SCHEMES = %w[http https ftp ftps]

    def self.valid?(url)
      uri = parse_uri(url)
      valid_scheme?(uri) && valid_hier_part?(uri) && domain_exists?(uri.host)
    end

    def self.validation_comment(uri)
      uri = parse_uri(uri)
      if uri.nil?
        "Invalid URL format"
      else
        if !valid_scheme?(uri)
          return "Invalid scheme"
        elsif !valid_hier_part?(uri)
          return "Empty or invalid hier-part"
        elsif !domain_exists?(uri.host)
          return "Domain doesn't exist"
        else
          return "Valid URL"
        end
      end
    end

    private

    def self.parse_uri(url)
      URI.parse(url)
    rescue URI::InvalidURIError
      nil
    end

    def self.valid_scheme?(uri)
      VALID_SCHEMES.include?(uri.scheme)
    end

    def self.valid_hier_part?(uri)
      uri.host && !uri.host.empty?
    end

    def self.domain_exists?(host)
      result = nil
      Resolv::DNS.open do |dns|
        result = dns.getresources(host, Resolv::DNS::Resource::IN::A)
      end
      !result.empty?
    rescue
      false
    end
  end
end
