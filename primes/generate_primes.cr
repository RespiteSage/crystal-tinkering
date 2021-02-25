require "benchmark"
require "./test_prime"

def generate_primes_naive(upto n)
  if n < 2
    return Array(Int64).new
  elsif n == 2
    return [2] of Int64
  end

  primes = [2] of Int64
  current = 3_i64
  while current <= n
    if is_prime? current
      primes << current
    end
    current += 2
  end
  primes
end

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

# guaranteed_primes = (2..1_000_000).select { |n| is_prime? n }.to_a
# # p! generate_primes_naive(upto: 1_000_000) == guaranteed_primes
# p! generate_primes_sqrt(upto: 1_000_000) == guaranteed_primes
# p! generate_primes_sqrtbound(upto: 1_000_000) == guaranteed_primes

puts ""

primes = [] of Int64

Benchmark.bm do |x|
  # x.report("naive") do
  #   generate_primes_naive upto: 10_000_000
  # end

  x.report("generate_primes_sqrt") do
    primes = generate_primes_sqrt upto: 1_000_000
  end

  x.report("generate_primes_sqrtbound") do
    primes = generate_primes_sqrtbound upto: 1_000_000
  end
end
