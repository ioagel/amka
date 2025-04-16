# frozen_string_literal: true

module Amka
  # Utility methods for the Amka module
  #
  # This class provides helper methods for parameter validation and date handling
  # that are used throughout the AMKA implementation. These utilities encapsulate
  # common validation logic and error handling to keep the main code cleaner.
  #
  # The methods primarily fall into these categories:
  # - String validation (digits only, format checking)
  # - Number validation
  # - Date validation and conversion
  #
  # All validation methods follow a consistent pattern: they either succeed silently
  # or raise descriptive ArgumentError exceptions.
  class Utils
    class << self
      # Validates that the input is a string with only digits
      #
      # Used when a value must be a non-empty string of digits, such as
      # an ID or number that needs to be processed digit by digit.
      #
      # @param id [String] the string to validate
      # @raise [ArgumentError] if the string is not all digits
      # @example
      #   Utils.string_with_digits_or_fail('12345')  # => nil (success)
      #   Utils.string_with_digits_or_fail('123abc') # => ArgumentError
      #   Utils.string_with_digits_or_fail('')       # => ArgumentError
      def string_with_digits_or_fail(id)
        return if id.is_a?(String) && id.match(/\A\d+\Z/)

        raise ArgumentError, "'#{id}': must be a string of digits only!"
      end

      # Validates that the input is a string with only digits or empty
      #
      # Similar to string_with_digits_or_fail but allows empty strings.
      # Used when an optional string of digits is expected.
      #
      # @param id [String] the string to validate
      # @raise [ArgumentError] if the string contains non-digits
      # @example
      #   Utils.string_with_digits_or_empty_or_fail('12345')  # => nil (success)
      #   Utils.string_with_digits_or_empty_or_fail('')       # => nil (success)
      #   Utils.string_with_digits_or_empty_or_fail('123abc') # => ArgumentError
      def string_with_digits_or_empty_or_fail(id)
        return if id.is_a?(String) && id.match(/\A\d*\Z/)

        raise ArgumentError, "'#{id}': must be a string of digits or even an empty one!"
      end

      # Validates that the input is a string with date in format dd/mm/yyyy
      #
      # Checks that the string follows the Greek date format where:
      # - Day can be 1 or 2 digits (1-31)
      # - Month can be 1 or 2 digits (1-12)
      # - Year must be 4 digits
      #
      # Note: This only checks the format, not if the date is valid
      # (e.g., 31/02/2022 would pass this check but is not a valid date)
      #
      # @param date [String] the date string to validate
      # @raise [ArgumentError] if the date format is invalid
      # @example
      #   Utils.string_with_date_or_fail('1/1/2020')   # => nil (success)
      #   Utils.string_with_date_or_fail('31/12/2020') # => nil (success)
      #   Utils.string_with_date_or_fail('2020-12-31') # => ArgumentError
      def string_with_date_or_fail(date)
        return if date.is_a?(String) && date.match(%r{\A\d?\d{1}/\d?\d{1}/\d{4}\Z})

        raise ArgumentError, 'date of birth must be in this format: [d]d/[m]m/yyyy'
      end

      # Validates that the input is a positive integer
      #
      # Used primarily for length/count parameters where negative or
      # zero values would be invalid.
      #
      # @param num [Integer] the number to validate
      # @raise [ArgumentError] if the number is not a positive integer
      # @example
      #   Utils.positive_integer_or_fail(10)  # => nil (success)
      #   Utils.positive_integer_or_fail(0)   # => ArgumentError
      #   Utils.positive_integer_or_fail(-5)  # => ArgumentError
      #   Utils.positive_integer_or_fail('5') # => ArgumentError
      def positive_integer_or_fail(num)
        return if num.is_a?(Integer) && num.positive?

        raise ArgumentError, "'#{num}': must be a non-zero positive integer!"
      end

      # Validates that the given date string is a valid date
      #
      # This is a more comprehensive date validation that:
      # 1. Checks the basic format
      # 2. Confirms the date actually exists in the calendar
      # 3. Optionally verifies it matches a specific 4-digit year
      #
      # This is particularly important for AMKA validation since the
      # first 6 digits must represent a valid date of birth.
      #
      # @param date [String] the date string to validate in format ddmmyy
      # @param year [String, nil] optional 4-digit year to check against
      # @return [Boolean] true if date is valid, false otherwise
      # @raise [ArgumentError] if year format or range is invalid
      # @example Simple validation (auto-guesses century)
      #   Utils.valid_date?('010190')  # => true (January 1, 1990)
      # @example With explicit year
      #   Utils.valid_date?('010190', '1990')  # => true
      #   Utils.valid_date?('010190', '2090')  # => ArgumentError
      def valid_date?(date, year = nil)
        return false unless date.match(/\A\d{6,}\Z/)

        if year
          validate_year_format(year, date)
          return validate_full_date(date, year)
        end

        validate_short_date(date)
      end

      private

      # Validates the year format and range
      #
      # @param year [String] the 4-digit year to validate
      # @param date [String] the date string (for year digit comparison)
      # @raise [ArgumentError] if year format or range is invalid
      def validate_year_format(year, date)
        unless year.is_a?(String) && year.match(/\A\d{4}\Z/)
          raise ArgumentError, 'Year must be a 4 digit string'
        end

        unless year.to_i.between?(1800, Date.today.year)
          raise ArgumentError, 'Year must be between 1800 and current!'
        end

        return if year[2..3] == date[4..5]

        raise ArgumentError, 'The last 2 digits of year parameter and the 2 digits ' \
                             'that correspond to the year in date must be equal!'
      end

      # Validates a date with a full 4-digit year
      #
      # Checks if the given date in DDMMYYYY format is valid and in the past.
      #
      # @param date [String] the date string (first 6 digits, format ddmmyy)
      # @param year [String] the 4-digit year
      # @return [Boolean] true if date is valid and in the past
      def validate_full_date(date, year)
        dob = Date.strptime(date[0..3] << year, '%d%m%Y')
        dob < Date.today
      rescue ArgumentError
        false
      end

      # Validates a date with just 2-digit year
      #
      # Handles the ambiguity of 2-digit years by trying to interpret
      # them as 20xx or 19xx years based on what makes sense.
      #
      # @param date [String] the date string (first 6 digits, format ddmmyy)
      # @return [Boolean] true if date is valid
      def validate_short_date(date)
        date_2_digit_year = Date.strptime(date[0..5], '%d%m%y')
        Date.strptime(date[0..3] << '19' << date[4..5], '%d%m%Y') if date_2_digit_year > Date.today
        true
      rescue ArgumentError
        false
      end
    end
  end
end
