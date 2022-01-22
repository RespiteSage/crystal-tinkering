require "bit_array"

struct BitArray
  def fill(value : Bool) : self
    @bits.to_slice(malloc_size).fill (value ? ~0u32 : 0u32)
    self
  end
end

def log_total_bytes(line)
  print line, ": ", (GC.stats.total_bytes / 1000), " kiB\n"
end

def sieve_of_eratosthenes(upto n)
  possible_primes = BitArray.new n + 1, initial: true
  possible_primes[0] = false
  possible_primes[1] = false

  (2..).take_while { |i| i <= Math.sqrt(n) }.each do |i|
    if possible_primes[i]?
      (i**2).upto(n).step(i).each do |j|
        possible_primes[j] = false
      end
    end
  end

  possible_primes.each_index.select { |index| possible_primes[index] }.to_a
end

def segmented_sieve_of_eratosthenes(upto n)
  log_total_bytes __LINE__

  delta = Math.sqrt(n).to_i

  known_primes = sieve_of_eratosthenes upto: delta

  log_total_bytes __LINE__

  # we know that, after the first instance, 2 will never be counted as prime, so we use it as a filler at the end
  # TODO: make sure this doesn't cause problems for small n
  possible_primes = BitArray.new delta
  (delta + 1).upto(n).step(delta).each do |segment_min|
    log_total_bytes __LINE__

    segment_max = segment_min + delta - 1
    prime_divisor_limit = Math.sqrt(segment_max)
    relevant_prime_divisors = known_primes.each.take_while { |prime| prime <= prime_divisor_limit }

    log_total_bytes __LINE__

    possible_primes.fill true

    log_total_bytes __LINE__

    pre_segment_min = segment_min - 1
    relevant_prime_divisors.each do |p|
      log_total_bytes __LINE__

      starting_index = p - (pre_segment_min % p) - 1
      starting_index.upto(delta - 1).step(p).each do |j|
        log_total_bytes __LINE__
        possible_primes[j] = false
        log_total_bytes __LINE__
      end
    end

    log_total_bytes __LINE__

    possible_primes.each_index do |index|
      if possible_primes[index]
        known_primes << (segment_min + index)
      end
    end

    log_total_bytes __LINE__
  end

  known_primes
end

if PROGRAM_NAME.ends_with? "sieve_of_eratosthenes"
  n = 100
  p! n
  sieve = segmented_sieve_of_eratosthenes(upto: n)
  p! GC.stats.total_bytes.humanize_bytes
end
