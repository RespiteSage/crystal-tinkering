require "./test_prime"

def generate_primes_naive(upto n)
  if n < 2
    return Array(Int64).new(initial_capacity: n // 6)
  elsif n == 2
    return [2] of Int64
  end

  primes = [2] of Int64
  current = 3_i64
  while current <= n
    unless divisible_by_any? current, primes
      primes << current
    end
    current += 2
  end
  primes
end
