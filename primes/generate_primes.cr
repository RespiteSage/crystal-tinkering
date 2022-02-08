require "benchmark"
require "./test_prime"
require "./generate_naive"
require "./generate_sqrt"
require "./generate_sqrtbound"
require "./sieve_of_eratosthenes"

guaranteed_primes = (2..1_000_000).select { |n| is_prime? n }.to_a
# p! generate_primes_naive(upto: 1_000_000) == guaranteed_primes
p! generate_primes_sqrt(upto: 1_000_000) == guaranteed_primes
p! generate_primes_sqrtbound(upto: 1_000_000) == guaranteed_primes
p! sieve_of_eratosthenes(upto: 1_000_000) == guaranteed_primes
p! segmented_sieve_of_eratosthenes(upto: 1_000_000) == guaranteed_primes

puts ""

primes = [] of Int64

Benchmark.ips do |x|
  {% for function_name in ["generate_primes_sqrt", "generate_primes_sqrtbound", "sieve_of_eratosthenes", "segmented_sieve_of_eratosthenes"] %}
  x.report({{function_name}}) do
    primes = {{function_name.id}} upto: 10_000_000
  end
  {% end %}
end
