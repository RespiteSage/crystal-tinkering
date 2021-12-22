def is_prime?(number)
  if number > 2 && number.divisible_by? 2
    return false
  end

  primes = [2] of Int32
  current = 3

  while current < Math.sqrt(number) + 1
    if number.divisible_by? current
      return false
    end

    if primes.none? { |prime| current.divisible_by? prime }
      primes << current
    end
    current += 2
  end

  true
end

def divisible_by_any?(number, divisor_list)
  divisor_list.any? { |divisor| number.divisible_by? divisor }
end

{% if PROGRAM_NAME == "test_prime" %}
  number_to_test = ARGV[0].to_i

  if is_prime?(number_to_test)
    puts "#{number_to_test} is prime"
  else
    puts "#{number_to_test} is composite"
  end
{% end %}
