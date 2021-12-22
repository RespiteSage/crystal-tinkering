require "benchmark"
require "./test_prime"
require "./generate_naive"
require "./generate_sqrt"
require "./generate_sqrtbound"

guaranteed_primes = (2..1_000_000).select { |n| is_prime? n }.to_a
p! generate_primes_naive(upto: 1_000_000) == guaranteed_primes
p! generate_primes_sqrt(upto: 1_000_000) == guaranteed_primes
p! generate_primes_sqrtbound(upto: 1_000_000) == guaranteed_primes

puts ""

primes = [] of Int64

Benchmark.bm do |x|
  x.report("naive") do
    generate_primes_naive upto: 10_000_000
  end

  x.report("generate_primes_sqrt") do
    primes = generate_primes_sqrt upto: 10_000_000
  end

  x.report("generate_primes_sqrtbound") do
    primes = generate_primes_sqrtbound upto: 10_000_000
  end
end
