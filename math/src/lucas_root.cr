require "./lucas/sequence"

class RootApproximations
  include Iterator(Float64)

  private property prev = 0
  private getter sequence : Lucas::Sequence::FirstKind

  def initialize(number_to_find_root_for)
    p = 2
    q = 1 - number_to_find_root_for

    @sequence = Lucas::Sequence::FirstKind.new(p, q)
  end

  def next : Float64
    value = sequence.next
    output = value / prev
    self.prev = value

    output
  end
end

def usage_string
  "Usage: #{PROGRAM_NAME} <number to find root for> <number of approximation steps>"
end

if ARGV.size != 2
  STDERR.puts "Wrong number of arguments!"
  STDERR.puts usage_string
  exit(1)
end

if ARGV[0].to_i?.nil?
  STDERR.puts "Invalid number to find root for!"
  STDERR.puts usage_string
  exit(1)
end

number_to_find_root_for = ARGV[0].to_i

if ARGV[1].to_i?.nil?
  STDERR.puts "Invalid number of approximation steps!"
  STDERR.puts usage_string
  exit(1)
end

approximation_steps = ARGV[1].to_i

ratios = RootApproximations.new(number_to_find_root_for)

(approximation_steps - 1).times { ratios.next }

puts ratios.next - 1
