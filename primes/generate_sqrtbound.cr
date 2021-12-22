require "./test_prime"

def generate_primes_sqrtbound(upto n)
  if n < 2
    return Array(Int64).new
  elsif n == 2
    return [2] of Int64
  end

  primes = [2] of Int64
  current = 3_i64
  sqrt_bound_index = 0

  while current <= n
    while sqrt_bound_index < (primes.size - 1) && current > primes[sqrt_bound_index] * primes[sqrt_bound_index + 1]
      sqrt_bound_index += 1
    end

    divisor_index = 0
    is_prime = true
    while divisor_index < primes.size && primes[divisor_index] <= primes[sqrt_bound_index]
      if current.divisible_by? primes[divisor_index]
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
