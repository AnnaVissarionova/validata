require 'resolv'

module Validata
  module EmailValidation
    PATTERN = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    def self.valid?(email)
      if email =~ PATTERN
        domain = email.split('@').last
        valid_domain?(domain)
      else
        false
      end
    end

    def self.validation_comment(email)
      if email =~ PATTERN
        return "Valid email address"
      else
        potential_email = email.gsub(/\s+/, "").downcase
        if email.include?("@")
          if potential_email.split('@').first.empty?
            return "Invalid email address. Missing username before '@'."
          elsif potential_email.split('@').last.empty?
            return "Invalid email address. Missing domain after '@'."
          elsif potential_email.split('@').last.split('.').length < 2
            return "Invalid email address. Missing third-level domain."
          else
            return "Invalid email address. Domain '#{potential_email.split('@').last}' does not exist."
          end
        else
          return "Invalid email address.You forget to include the '@' symbol."
        end
      end
    end

    private

    def self.valid_domain?(domain)
      mx_records_exist?(domain) || a_record_exists?(domain)
    end

    def self.mx_records_exist?(domain)
      mx = []
      ::Resolv::DNS.open do |dns|
        mx = dns.getresources(domain, ::Resolv::DNS::Resource::IN::MX)
      end
      mx.any?
    end

    def self.a_record_exists?(domain)
      a = []
      ::Resolv::DNS.open do |dns|
        a = dns.getresources(domain, ::Resolv::DNS::Resource::IN::A)
      end
      a.any?
    end
  end
end
