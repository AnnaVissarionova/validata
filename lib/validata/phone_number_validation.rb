require 'json'

module Validata
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
    ]
    def self.valid?(phone)


      PATTERNS.any? { |pattern| valid_with_country_code?(phone, pattern) }
    end

    def self.validation_comment(phone)
      if PATTERNS.any? { |pattern| phone =~ pattern }
        return "Valid phone"
      else
        if phone =~ /[^\d +()-]/
            return "Invalid phone number. It contains non-numeric characters"
        elsif !phone.start_with?("+")
            return "Invalid phone number. It should start with '+'"
        elsif !real_country_code?(phone)
            return "Invalid phone number. Country code doesn't exist."
        elsif phone.scan(/\d/).count > 15
            return "Invalid phone number. Too many digits in the phone number."
        elsif phone.scan(/\d/).count < 7
            return "Invalid phone number. Too few digits in the phone number."
        end

      end
    end

    private

    def self.valid_with_country_code?(phone, pattern)
      (phone =~ pattern) && real_country_code?(phone)
    end

    def self.real_country_code?(phone)
       json_data = JSON.parse(File.read('resources/CountryCodes.json'))

       json_data.each do |country|
          return true if phone.start_with?(country['dial_code'])
       end
       false
    end
  end
end
