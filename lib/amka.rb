# frozen_string_literal: true

require_relative 'amka/version'
require 'date'

# The Amka module provides functionality for validating and generating
# Greek A.M.K.A (social security) IDs as well as generic Luhn algorithm IDs.
# A.M.K.A IDs follow the Luhn algorithm and have their first 6 digits
# representing the date of birth in format DDMMYY.
#
# An AMKA (Αριθμός Μητρώου Κοινωνικής Ασφάλισης) is a unique 11-digit
# number assigned to each Greek citizen or resident who works, pays social
# security contributions, or is entitled to healthcare. It follows these rules:
#
# 1. The first 6 digits represent the date of birth in format DDMMYY
# 2. The remaining 5 digits include a check digit based on the Luhn algorithm
# 3. The total length is always 11 digits
#
# @example Validating an AMKA
#   Amka.valid?('01018012345')  #=> true or false
#
# @example Generating a random AMKA
#   Amka.generate  #=> "21129012345"
#
# @example Generating an AMKA with specific birth date
#   Amka.generate('21/12/1990')  #=> "21129012345"
#
# @author Ioannis Angelakopoulos
# @since 1.0.0
module Amka
  # Standard error class for the Amka gem
  class Error < StandardError; end

  # Validates whether a given string is a valid AMKA
  #
  # The validation checks three conditions:
  # 1. The AMKA must be exactly 11 digits long
  # 2. The first 6 digits must form a valid date (DDMMYY format)
  # 3. The entire number must satisfy the Luhn algorithm check
  #
  # @param amka [String] the AMKA to validate, must be a string containing only digits
  # @param year [String, nil] optional four-digit year to match against
  #   When provided, improves the validation by ensuring the birth year
  #   matches exactly (resolves century ambiguity in 2-digit years)
  # @return [Boolean] true if all validation criteria are met, false otherwise
  # @example Validating with default century assumption
  #   Amka.valid?('17019012345')  #=> true
  # @example Validating with explicit year
  #   Amka.valid?('17019012345', '1990')  #=> true
  def self.valid?(amka, year = nil)
    Utils.string_with_digits_or_fail(amka)

    return false unless length_is_11?(amka)

    return Luhn.valid?(amka) if Utils.valid_date?(amka, year)

    false
  end

  # Generates a random valid AMKA
  #
  # This method can create an AMKA with either:
  # - A random valid birth date (when called without parameters)
  # - A specific birth date (when called with a date parameter)
  #
  # The generated AMKA will always satisfy all validation rules:
  # - 11 digits in length
  # - First 6 digits form a valid date
  # - Passes the Luhn algorithm check
  #
  # @param date_of_birth [String, nil] optional date in format 'dd/mm/yyyy'
  # @return [String] a valid AMKA with the first 6 digits representing the
  #   birth date, and the remainder satisfying the Luhn algorithm
  # @example Generate a random AMKA
  #   Amka.generate  #=> "01011912345"
  # @example Generate an AMKA with specific birth date
  #   Amka.generate('1/1/1990')  #=> "01019012345"
  def self.generate(date_of_birth = nil)
    return generate_with_date_of_birth(date_of_birth) unless date_of_birth.nil?

    date_6_digits = String.new
    loop do
      day = "#{rand(0..3)}#{rand(0..9)}"
      next if day == '00' || day.to_i > 31

      month = "#{rand(0..1)}#{rand(0..2)}"
      next if month == '00' || month.to_i > 12

      year = "#{rand(19..20)}#{rand(0..9)}#{rand(0..9)}"
      next if year.to_i > Date.today.year

      date = day + month + year[2..3]
      if Utils.valid_date?(date, year)
        date_6_digits = date
        break
      end
    end

    Luhn.generate(11, date_6_digits)
  end

  # Generates an AMKA with a specific date of birth
  #
  # @param date_of_birth [String] date in format 'dd/mm/yyyy'
  #   Day and month can be either 1 or 2 digits
  #   Year must be 4 digits
  # @return [String] a valid AMKA with the given date of birth
  # @raise [ArgumentError] if date format is invalid or date is invalid
  # @example
  #   Amka.generate_with_date_of_birth('1/12/1980')  #=> "01128012345"
  # @example Invalid date raises an error
  #   Amka.generate_with_date_of_birth('31/2/1990')
  #   #=> ArgumentError: The date of birth is invalid!
  def self.generate_with_date_of_birth(date_of_birth)
    Utils.string_with_date_or_fail(date_of_birth)

    day, month, year = date_of_birth.split('/').map { |i| i.length == 1 ? "0#{i}" : i }
    date_6_digit = day + month + year[2..3]
    unless Utils.valid_date?(date_6_digit, year)
      raise ArgumentError, 'The date of birth is invalid!'
    end

    Luhn.generate(11, date_6_digit)
  end
  private_class_method :generate_with_date_of_birth

  # Checks if the ID has exactly 11 digits
  #
  # AMKA numbers are required to be exactly 11 digits in length.
  # This is a validation helper method.
  #
  # @param id [String] the ID to check
  # @return [Boolean] true if length is 11, false otherwise
  def self.length_is_11?(id)
    id.length == 11
  end
  private_class_method :length_is_11?
end

require_relative 'amka/luhn'
require_relative 'amka/utils'
