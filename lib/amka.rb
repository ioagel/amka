require 'amka/version'
require 'date'

module Amka

  def self.valid?(amka, year = nil)
    Utils.string_with_digits_or_fail amka

    return false unless length_is_11?(amka)

    return Luhn.valid?(amka) if Utils.valid_date?(amka, year)

    false
  end

  def self.generate(date_of_birth = nil)
    return generate_with_date_of_birth(date_of_birth) unless date_of_birth.nil?

    date_6_digits = ''
    loop do
      day = rand(0..3).to_s << rand(0..9).to_s
      next if day == '00' || day.to_i > 31
      month = rand(0..1).to_s << rand(0..2).to_s
      next if month == '00' || month.to_i > 12
      year = rand(19..20).to_s << rand(0..9).to_s << rand(0..9).to_s
      next if year.to_i > Date.today.year

      if Utils.valid_date?(date = day << month << year[2..3], year)
        date_6_digits = date
        break
      end
    end

    Luhn.generate(11, date_6_digits)
  end

  def self.generate_with_date_of_birth(date_of_birth)
    Utils.string_with_date_or_fail date_of_birth

    day, month, year = date_of_birth.split('/').map { |i| i.length == 1 && ('0' << i) or i }
    date_6_digit = day << month << year[2..3]
    fail ArgumentError, 'The date of birth is invalid!' unless Utils.valid_date?(date_6_digit, year)

    Luhn.generate(11, date_6_digit)
  end
  private_class_method :generate_with_date_of_birth

  def self.length_is_11?(id)
    id.length == 11
  end
  private_class_method :length_is_11?

end

require 'amka/luhn'
require 'amka/utils'
