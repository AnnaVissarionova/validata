# frozen_string_literal: true

module Validata
  module CustomValidators
    # This class allows to set custom email validation rules
    class EmailValidator
      attr_reader :name, :pattern, :max_length, :min_length, :allowed_domains, :blocked_domains

      def initialize(name, pattern: nil, max_length: 254, min_length: 5,
                     allowed_domains: [], blocked_domains: [])
        @name = name
        @pattern = pattern || EmailValidation::PATTERN
        @max_length = max_length
        @min_length = min_length
        @allowed_domains = allowed_domains
        @blocked_domains = blocked_domains
      end

      def valid?(email)
        validate_format(email) &&
          validate_length(email) &&
          validate_allowed_domains(email) &&
          validate_blocked_domains(email) &&
          validate_mx_records(email)
      end

      private

      def validate_format(email)
        !!(email =~ pattern)
      end

      def validate_length(email)
        email.length <= max_length && email.length >= min_length
      end

      def validate_allowed_domains(email)
        return true if allowed_domains.empty?

        domain = email.split("@").last
        allowed_domains.include?(domain)
      end

      def validate_blocked_domains(email)
        domain = email.split("@").last
        !blocked_domains.include?(domain)
      end

      def validate_mx_records(email)
        domain = email.split("@").last
        mx_records_exist?(domain)
      end

      def mx_records_exist?(domain)
        mx = []
        ::Resolv::DNS.open do |dns|
          mx = dns.getresources(domain, ::Resolv::DNS::Resource::IN::MX)
        end
        mx.any?
      end
    end
  end
end
