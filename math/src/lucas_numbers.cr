require "./lucas/numbers"

def usage_string
  "Usage: #{PROGRAM_NAME} <number of sequence elements>"
end

if ARGV.size != 1
  STDERR.puts "Wrong number of arguments!"
  STDERR.puts usage_string
  exit(1)
end

if ARGV[0].to_i?.nil?
  STDERR.puts "Invalid number of elements!"
  STDERR.puts usage_string
  exit(1)
end

element_count = ARGV[0].to_i

seq_gen = Lucas::Numbers.iterator
ratios = Lucas::Numbers::Sequence.ratios

puts seq_gen.first(element_count).join(",")
puts ratios.first(element_count).join(",")
