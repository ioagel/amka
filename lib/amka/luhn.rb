# Implements the Luhn algorithm as described in the wikipedia article
# https://en.wikipedia.org/wiki/Luhn_algorithm
class Luhn

  def self.valid?(string_of_numbers)
    return false unless string_of_numbers.match(/\A\d+\Z/)

    digits_sum = calculate_digits_sum(string_of_numbers)

    (digits_sum % 10) == 0
  end

  def self.generate_luhn(date_first_6_digits)
    loop do
      last_4_digits_except_check = ''
      4.times { last_4_digits_except_check << rand(0..9).to_s }
      amka_except_check_digit = date_first_6_digits << last_4_digits_except_check

      digits_sum = calculate_digits_sum(amka_except_check_digit, true)

      check_digit = (digits_sum * 9) % 10

      amka = amka_except_check_digit << check_digit.to_s
      return amka if Luhn.valid?(amka)
    end
  end

  def self.calculate_digits_sum(string_of_numbers, generate = false)
    digits_sum = 0
    string_of_numbers.split('').reverse.each_with_index do |digit_str, index|
      digit = digit_str.to_i
      if (!generate && index.odd?) || (generate && index.even?)
        if (digit *= 2) > 9
          digit = digit.to_s[0].to_i + digit.to_s[1].to_i
        end
      end
      digits_sum += digit
    end
    digits_sum
  end
  private_class_method :calculate_digits_sum

end
