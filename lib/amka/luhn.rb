# frozen_string_literal: true

module Amka
  # Implements the Luhn algorithm as described in the wikipedia article
  # https://en.wikipedia.org/wiki/Luhn_algorithm
  #
  # The Luhn algorithm (also known as the "modulus 10" or "mod 10" algorithm)
  # is a simple checksum formula used to validate various identification numbers,
  # such as credit card numbers, IMEI numbers, and national identification numbers
  # (like AMKA in Greece).
  #
  # ## Algorithm Steps
  # 1. Starting from the rightmost digit, double the value of every second digit
  # 2. If doubling a number results in a two-digit number (>9), subtract 9 from the result
  # 3. Sum all digits (both doubled and non-doubled)
  # 4. If the total modulo 10 is 0, then the number is valid
  #
  # ## Uses
  # This class provides both validation of existing IDs and generation of
  # new valid IDs that follow the Luhn algorithm.
  #
  # @example Validate a Luhn ID
  #   Amka::Luhn.valid?('79927398713')  #=> true
  #
  # @example Generate a new Luhn ID of specified length
  #   Amka::Luhn.generate(10)  #=> "7992739871"
  #
  # @example Generate a Luhn ID with a specific prefix
  #   Amka::Luhn.generate(16, '4532')  #=> "4532015112830366"
  class Luhn
    # Validates if a given ID follows the Luhn algorithm
    #
    # Applies the standard Luhn algorithm to check if a number is valid:
    # 1. From the rightmost digit, double every second digit
    # 2. Sum the digits (if any doubled digit > 9, subtract 9)
    # 3. If the sum is divisible by 10, the number is valid
    #
    # @param luhn_id [String] the ID to validate, must be a string containing only digits
    # @return [Boolean] true if valid according to Luhn algorithm, false otherwise
    # @raise [ArgumentError] if the ID is not a string of digits
    # @example Validating a credit card number
    #   Amka::Luhn.valid?('4532015112830366')  #=> true
    # @example Validating an invalid number
    #   Amka::Luhn.valid?('1234567890')  #=> false
    def self.valid?(luhn_id)
      Utils.string_with_digits_or_fail(luhn_id)

      digits_sum = calculate_digits_sum(luhn_id)

      (digits_sum % 10).zero?
    end

    # Generates a valid Luhn ID
    #
    # Creates a number that passes the Luhn check by:
    # 1. Taking the provided prefix (or creating a random one)
    # 2. Calculating what the check digit should be for the number to be valid
    # 3. Appending the check digit to create a valid Luhn number
    #
    # @param total [Integer] the total length of the ID to generate
    # @param id_start [String] optional digits to use at the start of the ID
    # @return [String] a valid Luhn ID of exactly 'total' length
    # @raise [ArgumentError] if arguments are invalid
    # @example Generate a 16-digit number (like a credit card)
    #   Amka::Luhn.generate(16)  #=> "4532015112830366"
    # @example Generate a number with a specific prefix
    #   Amka::Luhn.generate(10, '123456')  #=> "1234567897"
    # @example Special case for length 1
    #   Amka::Luhn.generate(1)  #=> "0"
    def self.generate(total, id_start = '')
      validate_generate_args_or_fail(total, id_start)
      return '0' if id_start.empty? && total == 1

      last_digits_length = total - id_start.length
      # Use String.new to create an unfrozen string
      last_digits_except_check = String.new
      # subtract by one to account for the check digit
      (last_digits_length - 1).times { last_digits_except_check << rand(0..9).to_s }
      # Using + instead of << for string concatenation to prevent frozen string issues
      luhn_id_except_check_digit = id_start + last_digits_except_check

      digits_sum = calculate_digits_sum(luhn_id_except_check_digit, generate: true)

      check_digit = (digits_sum * 9) % 10

      luhn_id_except_check_digit + check_digit.to_s
    end

    # Calculates the sum of digits according to the Luhn algorithm
    #
    # This implementation handles both validation of existing numbers and
    # generation of new numbers with the 'generate' parameter determining the pattern
    # of which digits to double.
    #
    # @param luhn_id [String] the ID to calculate the sum for
    # @param generate [Boolean] whether we're generating (affects digit doubling pattern)
    # @return [Integer] the sum of digits according to Luhn algorithm rules
    def self.calculate_digits_sum(luhn_id, generate: false)
      luhn_id_double = luhn_id.chars.reverse.map(&:to_i).map.with_index do |digit, i|
        if ((!generate && i.odd?) || (generate && i.even?)) && ((digit *= 2) > 9)
          # Same as: digit = digit.to_s.chars.map(&:to_i).reduce(:+)
          digit -= 9
        end
        digit
      end
      luhn_id_double.reduce(:+)
    end
    private_class_method :calculate_digits_sum

    # Validates the arguments for the generate method
    #
    # Performs several checks:
    # 1. Ensures id_start is a string containing only digits (or empty)
    # 2. Ensures total is a positive integer
    # 3. Ensures total > id_start.length to allow room for the check digit
    #
    # @param total [Integer] the total length of the ID to generate
    # @param id_start [String] digits to use at the start of the ID
    # @raise [ArgumentError] if arguments are invalid
    def self.validate_generate_args_or_fail(total, id_start)
      Utils.string_with_digits_or_empty_or_fail(id_start)
      Utils.positive_integer_or_fail(total)

      return if total > id_start.length

      raise ArgumentError, "'#{total}': must be greater at least by one from string length: " \
                           "#{id_start.length}, to account for the check digit!"
    end
    private_class_method :validate_generate_args_or_fail
  end
end
