# frozen_string_literal: true

require "json"

module Validata
  # This module allows to validate phone numbers
  module PhoneNumberValidation
    PATTERNS = [
      # Общий формат с кодом страны
      /\A\+[1-9]\d{1,14}\z/,
      # Формат с разделителями
      /\A\+\d{1,3}-?\d{2,3}-?\d{6,9}\z/,
      # Формат с пробелами
      /\A\+\d{1,3} \d{2,3} \d{6,9}\z/,
      # Формат с кодом страны в скобках
      /\A\+\d{1,3}\(\d{2,3}\)\d{6,9}\z/
    ].freeze

    def self.valid?(phone)
      PATTERNS.any? { |pattern| valid_with_country_code?(phone, pattern) }
    end

    def self.validation_comment(phone)
      if PATTERNS.any? { |pattern| phone.match?(pattern) }
        "Valid phone"
      elsif phone.match?(/[^\d +()-]/)
        "Invalid phone number. It contains non-numeric characters"
      elsif !phone.start_with?("+")
        "Invalid phone number. It should start with '+'"
      elsif !real_country_code?(phone)
        "Invalid phone number. Country code doesn't exist."
      elsif phone.scan(/\d/).count > 15
        "Invalid phone number. Too many digits in the phone number."
      elsif phone.scan(/\d/).count < 7
        "Invalid phone number. Too few digits in the phone number."
      end
    end

    def self.valid_with_country_code?(phone, pattern)
      phone.match?(pattern) && real_country_code?(phone)
    end

    def self.real_country_code?(phone)
      json_data = JSON.parse(File.read("resources/CountryCodes.json"))

      json_data.each do |country|
        return true if phone.start_with?(country["dial_code"])
      end
      false
    end
  end
end
