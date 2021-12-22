require "./test_prime"

def generate_primes_sqrt(upto n)
  if n < 2
    return Array(Int64).new
  elsif n == 2
    return [2] of Int64
  end

  primes = [2] of Int64
  current = 3_i64

  while current <= n
    divisor_index = 0
    is_prime = true
    while (divisor = primes[divisor_index]) <= Math.sqrt(current)
      if current.divisible_by? divisor
        is_prime = false
        break
      end
      divisor_index += 1
    end

    if is_prime
      primes << current
    end
    current += 2
  end

  primes
end
