# frozen_string_literal: true

# LuhnValidator module provides credit card number validation
module LuhnValidator
  # Validates credit card number using Luhn Algorithm
  # arguments: none
  # assumes: a local String called 'number' exists
  # returns: true/false whether last digit is correct
  def validate_checksum
    nums_a = number.to_s.chars.map(&:to_i)
    validate_with_digits(nums_a)
  end

  private

  def validate_with_digits(digits)
    sum = calculate_sum(digits[0...-1])
    check_digit = digits.last
    ((sum + check_digit) % 10).zero?
  end

  def calculate_sum(digits)
    sum = 0
    digits.reverse.each_with_index do |digit, i|
      sum += if i.even?
               double_digit(digit)
             else
               digit
             end
    end
    sum
  end

  def double_digit(digit)
    doubled = digit * 2
    doubled > 9 ? doubled - 9 : doubled
  end
end
