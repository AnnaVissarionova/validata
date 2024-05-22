require 'iso_country_codes'
module Validata
  module PhoneNumberValidation
    def self.valid?(phone)
      patterns = [
        # Общий формат с кодом страны
        /\A\+[1-9]\d{1,14}\z/,
        # Формат с разделителями
        /\A\+\d{2,3}-?\d{2,3}-?\d{6,9}\z/,
        # Формат с пробелами
        /\A\+\d{2,3} \d{2,3} \d{6,9}\z/,
        # Формат с кодом страны в скобках
        /\A\+\d{2,3}\(\d{2,3}\)\d{6,9}\z/
      ]

      patterns.any? { |pattern| valid_with_country_code?(phone, pattern) }
    end

    private

    def self.valid_with_country_code?(phone, pattern)
      (phone =~ pattern) && real_country_code?(phone)
    end

    def self.real_country_code?(phone)
      country_code_1 = phone[/\A\+(\d)/, 1]
      country_code_2 = phone[/\A\+(\d{2})/, 1]
      country_code_3 = phone[/\A\+(\d{3})/, 1]

      !IsoCountryCodes.search_by_calling_code(country_code_1).nil? ||
        !IsoCountryCodes.search_by_calling_code(country_code_2).nil? ||
        !IsoCountryCodes.search_by_calling_code(country_code_3).nil?
    rescue IsoCountryCodes::UnknownCodeError => e
      return false
    end
  end
end
