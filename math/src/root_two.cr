require "./lucas/static_sequence"

class PellRatios
  include Iterator(Float64)

  private getter sequence = Lucas::StaticSequence::FirstKind(2, -1).new
  private property prev = 0

  def next : Float64
    value = sequence.next
    output = prev / value + 1
    self.prev = value

    output
  end
end

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

ratios = PellRatios.new

(approximation_steps - 1).times { ratios.next }

puts ratios.next
