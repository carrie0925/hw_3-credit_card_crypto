module LuhnValidator
  # Validates credit card number using Luhn Algorithm
  # arguments: none
  # assumes: a local String called 'number' exists
  # returns: true/false whether last digit is correct
  def validate_checksum
    nums_a = number.to_s.chars.map(&:to_i)

    # TODO: use the integers in nums_a to validate its last check digit
    sum = 0
    nums_a[0...-1].reverse.each_with_index do |digit, i|
      if i.even?
        doubled = digit * 2
        doubled = doubled > 9 ? doubled - 9 : doubled
        sum += doubled
      else
        sum += digit
      end
    end
    check_digit = nums_a.last
    (sum + check_digit) % 10 == 0
  end
end
