require "./lucas/numbers"

def usage_string
  "Usage: #{PROGRAM_NAME} <number of approximation steps>"
end

if ARGV.size != 1
  STDERR.puts "Wrong number of arguments!"
  STDERR.puts usage_string
  exit(1)
end

if ARGV[0].to_i?.nil?
  STDERR.puts "Invalid number of approximation steps!"
  STDERR.puts usage_string
  exit(1)
end

approximation_steps = ARGV[0].to_i

ratios = Lucas::Numbers::RatioIterator.new

(approximation_steps - 1).times { ratios.next }

puts ratios.next * 2 - 1
