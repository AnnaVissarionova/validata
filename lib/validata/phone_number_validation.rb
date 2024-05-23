require 'json'

module Validata
  module PhoneNumberValidation
    def self.valid?(phone)
      patterns = [
        # Общий формат с кодом страны
        /\A\+[1-9]\d{1,14}\z/,
        # Формат с разделителями
        /\A\+\d{1,3}-?\d{2,3}-?\d{6,9}\z/,
        # Формат с пробелами
        /\A\+\d{1,3} \d{2,3} \d{6,9}\z/,
        # Формат с кодом страны в скобках
        /\A\+\d{1,3}\(\d{2,3}\)\d{6,9}\z/
      ]

      patterns.any? { |pattern| valid_with_country_code?(phone, pattern) }
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
