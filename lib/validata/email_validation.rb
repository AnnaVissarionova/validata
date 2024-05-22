require 'resolv'

module Validata
  module EmailValidation
    def self.valid?(email)
      pattern = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      if email =~ pattern
        domain = email.split('@').last
        valid_domain?(domain)
      else
        false
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
