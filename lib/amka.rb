require 'amka/version'
require 'date'

module Amka

  def self.valid?(amka)
    return false unless amka.length == 11

    return Luhn.valid?(amka) if valid_date?(amka)

    false
  end

  def self.generate
    date_first_6_digits = ''
    loop do
      day = rand(0..3).to_s << rand(0..9).to_s
      next if day == '00' || day.to_i > 31
      month = rand(0..1).to_s << rand(0..2).to_s
      next if month == '00' || month.to_i > 12
      year = rand(0..9).to_s << rand(0..9).to_s

      if valid_date?(date = day << month << year)
        date_first_6_digits = date
        break
      end
    end

    Luhn.generate_luhn(date_first_6_digits)
  end

  def self.valid_date?(amka)
    return false unless amka.match(/\A\d{6,}\Z/)

    begin
      date_2_digit_year = Date.strptime(amka[0..5], '%d%m%y')
      if date_2_digit_year > Date.today
        Date.strptime(amka[0..3] << '19' << amka[4..5], '%d%m%Y')
      end
    rescue ArgumentError
      return false
    end

    true
  end
  private_class_method :valid_date?

end

require 'amka/luhn'
