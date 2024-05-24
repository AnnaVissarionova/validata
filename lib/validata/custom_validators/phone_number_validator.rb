
module Validata
  module CustomValidators
    class PhoneNumberValidator
      attr_reader :name, :patterns, :max_length, :min_length, :allowed_country_codes,
      :blocked_country_codes, :allowed_regions, :blocked_regions, :internal_codes,
      :country_code_pattern, :region_code_pattern

      def initialize(name, patterns: [], max_length: 15, min_length: 7, allowed_country_codes: [],
        blocked_country_codes: [], allowed_regions: [], blocked_regions: [], internal_codes: [],
        country_code_pattern: /\A\+(\d{1,4})/, region_code_pattern: /\A\+\d{1,4}(\(\d{2,3}\))/)

        @name = name
        @patterns = patterns || PhoneNumberValidation::PATTERNS
        @max_length = max_length
        @min_length = min_length
        @allowed_country_codes = allowed_country_codes
        @blocked_country_codes = blocked_country_codes
        @allowed_regions = allowed_regions
        @blocked_regions = blocked_regions
        @internal_codes = internal_codes
        @country_code_pattern = country_code_pattern
        @region_code_pattern = region_code_pattern
      end

      def valid?(phone)
        validate_format(phone) &&
        validate_length(phone) &&
        validate_allowed_country_codes(phone) &&
        validate_blocked_country_codes(phone) &&
        validate_allowed_regions(phone) &&
        validate_blocked_regions(phone) &&
        validate_internal_codes(phone)
      end

      def allow_country_code(code)
        @allowed_country_codes << code
      end

      def block_country_code(code)
        @blocked_country_codes << code
      end

      def allow_region(code)
        @allowed_regions << code
      end

      def block_region(code)
        @blocked_regions << code
      end

      def add_internal_code(code)
        @internal_codes << code
      end

      private

      def validate_format(phone)
         @patterns.any? { |pattern| phone =~ pattern }
      end

      def validate_length(phone)
        phone.length <= max_length && phone.length >= min_length
      end

      def validate_allowed_country_codes(phone)
        return true if allowed_country_codes.empty?
        country_code = extract_country_code(phone)
        allowed_country_codes.include?(country_code)
      end

      def validate_blocked_country_codes(phone)
        country_code = extract_country_code(phone)
        !blocked_country_codes.include?(country_code)
      end

      def validate_allowed_regions(phone)
        return true if allowed_regions.empty?
        region_code = extract_region_code(phone)
        allowed_regions.include?(region_code)
      end

      def validate_blocked_regions(phone)
        return true if blocked_regions.empty?
        region_code = extract_region_code(phone)
        !blocked_regions.include?(region_code)
      end

      def validate_internal_codes(phone)
        return true if internal_codes.empty?
        internal_codes.any? { |code| phone.include?(code) }
      end

      def extract_country_code(phone)
        phone[country_code_pattern, 1]
      end

      def extract_region_code(phone)
        match_data = @region_code_pattern.match(phone)
        match_data ? match_data[1] : nil
      end


    end

  end
end
