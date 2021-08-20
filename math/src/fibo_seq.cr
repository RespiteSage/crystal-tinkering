require "./phi/fibo_generator"

if ARGV.size != 1
  STDERR.puts "Wrong number of arguments!"
  STDERR.puts "Usage: #{PROGRAM_NAME} <number of sequence elements>"
  exit(1)
end

element_count = ARGV[0].to_i

seq_gen = Fibo::SequenceGenerator.new
ratio_gen = Fibo::SequenceGenerator.ratios

puts seq_gen.first(element_count).join(",")
puts ratio_gen.first(element_count).join(",")
