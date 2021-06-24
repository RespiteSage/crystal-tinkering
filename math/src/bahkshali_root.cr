def bahkshali_root_method(number_to_find_root_for, initial_guess, approximation_steps)
  approximation = initial_guess

  approximation_steps.times do
    a = (number_to_find_root_for - approximation ** 2) / (2 * approximation)
    b = approximation + a
    approximation = b - (a ** 2 / (2 * b))
  end

  approximation
end

def usage_string
  "Usage: #{PROGRAM_NAME} <number to find root for> <initial guess> <number of approximation steps>"
end

if ARGV.size != 3
  STDERR.puts "Wrong number of arguments!"
  STDERR.puts usage_string
  exit(1)
end

if ARGV[0].to_f?.nil?
  STDERR.puts "Invalid number to find root for!"
  STDERR.puts usage_string
  exit(1)
end

number_to_find_root_for = ARGV[0].to_f

if ARGV[1].to_f?.nil?
  STDERR.puts "Invalid initial guess!"
  STDERR.puts usage_string
  exit(1)
end

initial_guess = ARGV[1].to_f

if ARGV[2].to_i?.nil?
  STDERR.puts "Invalid number of approximation steps!"
  STDERR.puts usage_string
  exit(1)
end

approximation_steps = ARGV[2].to_i

puts bahkshali_root_method(number_to_find_root_for, initial_guess, approximation_steps)
