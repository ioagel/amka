module Amka

  class Utils
    class << self
      def string_with_digits_or_fail(id)
        id.is_a?(String) && id.match(/\A\d+\Z/) or
          fail ArgumentError, "'#{id}': must be a string of digits only!"
      end

      def string_with_digits_or_empty_or_fail(id)
        id.is_a?(String) && id.match(/\A\d*\Z/) or
          fail ArgumentError, "'#{id}': must be a string of digits or even an empty one!"
      end

      def string_with_date_or_fail(date)
        date.is_a?(String) && date.match(%r{\A\d?\d{1}/\d?\d{1}/\d{4}\Z}) or
          fail ArgumentError, 'date of birth must be in this format: [d]d/[m]m/yyyy'
      end

      def positive_integer_or_fail(num)
        num.is_a?(Integer) && num > 0 or
          fail ArgumentError, "'#{num}': must be a non-zero positive integer!"
      end

      def valid_date?(date, year = nil)
        return false unless date.match(/\A\d{6,}\Z/)

        unless year.nil?
          year.is_a?(String) && year.match(/\A\d{4}\Z/) or
            fail ArgumentError, 'Year must be a 4 digit string'
          year.to_i >= 1800 && year.to_i <= Date.today.year or
            fail ArgumentError, 'Year must be between 1800 and current!'
          year[2..3] == date[4..5] or
            fail ArgumentError, 'The last 2 digits of year parameter and the 2 digits'\
                                ' that correspond to the year in date must be equal!'
          begin
            dob = Date.strptime(date[0..3] << year, '%d%m%Y')
            return dob < Date.today
          rescue ArgumentError
            return false
          end
        end

        begin
          date_2_digit_year = Date.strptime(date[0..5], '%d%m%y')
          if date_2_digit_year > Date.today
            Date.strptime(date[0..3] << '19' << date[4..5], '%d%m%Y')
          end
          return true
        rescue ArgumentError
          return false
        end
      end
    end
  end

end
