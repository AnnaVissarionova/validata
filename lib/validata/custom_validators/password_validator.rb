# frozen_string_literal: true

module Validata
  module CustomValidators
    # This class allows to set custom password validation rules
    class PasswordValidator
      attr_reader :name, :min_length, :max_length, :require_uppercase, :require_lowercase,
                  :require_digit, :require_special, :blocked_chars

      SPECIAL_CHARACTERS = /[!@#$%^&*(),.?":{}|<>]/

      def initialize(name, min_length: 8, max_length: 128, require_uppercase: true,
                     require_lowercase: true, require_digit: true, require_special: true,
                     blocked_chars: [])
        @name = name
        @min_length = min_length
        @max_length = max_length
        @require_uppercase = require_uppercase
        @require_lowercase = require_lowercase
        @require_digit = require_digit
        @require_special = require_special
        @blocked_chars = blocked_chars
      end

      def valid?(password)
        validate_length(password) &&
          validate_uppercase(password) &&
          validate_lowercase(password) &&
          validate_digit(password) &&
          validate_special(password) &&
          validate_blocked_chars(password)
      end

      private

      def validate_length(password)
        password.length >= @min_length && password.length <= @max_length
      end

      def validate_uppercase(password)
        return true unless @require_uppercase

        !!password.match(/[A-Z]/)
      end

      def validate_lowercase(password)
        return true unless @require_lowercase

        !!password.match(/[a-z]/)
      end

      def validate_digit(password)
        return true unless @require_digit

        !!password.match(/\d/)
      end

      def validate_special(password)
        return true unless @require_special

        !!password.match(SPECIAL_CHARACTERS)
      end

      def validate_blocked_chars(password)
        return true if @blocked_chars.empty?

        !password.match(Regexp.new("[#{@blocked_chars.join}]"))
      end
    end
  end
end
