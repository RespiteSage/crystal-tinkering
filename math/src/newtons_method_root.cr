def newtons_method_root(number_to_find_root_for, degree_of_root, initial_guess, approximation_steps)
  approximation = initial_guess
  a = (degree_of_root - 1) / degree_of_root
  b = number_to_find_root_for / degree_of_root

  approximation_steps.times do
    # approximation = (approximation + number_to_find_root_for / approximation) / 2
    approximation = a * approximation + (b / approximation ** (degree_of_root - 1))
  end

  approximation
end

def usage_string
  "Usage: #{PROGRAM_NAME} <number to find root for> <degree of root> <initial guess> <number of approximation steps>"
end

if ARGV.size != 4
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
  STDERR.puts "Invalid degree of root!"
  STDERR.puts usage_string
  exit(1)
end

degree_of_root = ARGV[1].to_f

if ARGV[2].to_f?.nil?
  STDERR.puts "Invalid initial guess!"
  STDERR.puts usage_string
  exit(1)
end

initial_guess = ARGV[2].to_f

if ARGV[3].to_i?.nil?
  STDERR.puts "Invalid number of approximation steps!"
  STDERR.puts usage_string
  exit(1)
end

approximation_steps = ARGV[3].to_i

puts newtons_method_root(number_to_find_root_for, degree_of_root, initial_guess, approximation_steps)
