require 'amka/version'
require 'date'

module Amka

  def self.valid?(amka, year = nil)
    Utils.string_with_digits_or_fail amka

    return false unless amka.length == 11

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
    date_of_birth.is_a?(String) && date_of_birth.match(%r{\A\d?\d{1}/\d?\d{1}/\d{4}\Z}) or
      fail ArgumentError, 'date of birth must be in this format: 23/11/1990!'

    day, month, year = date_of_birth.split('/').map do |i|
      if i.length == 1
        '0' << i
      else
        i
      end
    end
    date_6_digit = day << month << year[2..3]
    fail ArgumentError, 'The date of birth is invalid!' unless Utils.valid_date?(date_6_digit, year)

    Luhn.generate(11, date_6_digit)
  end
  private_class_method :generate_with_date_of_birth

end

require 'amka/luhn'
require 'amka/utils'
