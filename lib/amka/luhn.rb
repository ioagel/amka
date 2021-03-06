module Amka
  # Implements the Luhn algorithm as described in the wikipedia article
  # https://en.wikipedia.org/wiki/Luhn_algorithm
  class Luhn

    def self.valid?(luhn_id)
      Utils.string_with_digits_or_fail luhn_id

      digits_sum = calculate_digits_sum(luhn_id)

      (digits_sum % 10) == 0
    end

    def self.generate(total, id_start = '')
      validate_generate_args_or_fail(total, id_start)
      id_start == '' && total == 1 and return '0'

      last_digits_length = total - id_start.length
      last_digits_except_check = ''
      # subtract by one to account for the check digit
      (last_digits_length - 1).times { last_digits_except_check << rand(0..9).to_s }
      luhn_id_except_check_digit = id_start << last_digits_except_check

      digits_sum = calculate_digits_sum(luhn_id_except_check_digit, true)

      check_digit = (digits_sum * 9) % 10

      luhn_id_except_check_digit << check_digit.to_s
    end

    def self.calculate_digits_sum(luhn_id, generate = false)
      luhn_id_double = luhn_id.chars.reverse.map(&:to_i).map.with_index do |digit, i|
        if (!generate && i.odd?) || (generate && i.even?)
          if (digit *= 2) > 9
            # digit = digit.to_s.chars.map(&:to_i).reduce(:+)
            digit -= 9
          end
        end
        digit
      end
      luhn_id_double.reduce(:+)
    end
    private_class_method :calculate_digits_sum

    def self.validate_generate_args_or_fail(total, id_start)
      Utils.string_with_digits_or_empty_or_fail id_start
      Utils.positive_integer_or_fail total
      total > id_start.length or
        fail ArgumentError, "'#{total}': must be greater at least by one from string length: "\
                            "#{id_start.length}, to account for the check digit!"
    end
    private_class_method :validate_generate_args_or_fail

  end
end
