# frozen_string_literal: true

require "resolv"

module Validata
  # This module allows to validate emails
  module EmailValidation
    PATTERN = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    def self.valid?(email)
      if email.match?(PATTERN)
        domain = email.split("@").last
        valid_domain?(domain)
      else
        false
      end
    end

    def self.validation_comment(email)
      return "Valid email address" if email.match?(PATTERN)


      potential_email = email.gsub(/\s+/, "").downcase
      return "Invalid email address. You forget to include the '@' symbol." unless email.include?("@")

      if potential_email.split("@").first.empty?
        "Invalid email address. Missing username before '@'."
      elsif potential_email.split("@").last.empty?
        "Invalid email address. Missing domain after '@'."
      elsif potential_email.split("@").last.split(".").length < 2
        "Invalid email address. Missing third-level domain."
      else
        "Invalid email address. Domain '#{potential_email.split("@").last}' does not exist."
      end
    end

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
