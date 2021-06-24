module Fibo
  class SequenceGenerator
    include Iterator(Int32)

    private property current_value : Int32 = 0
    private property next_value : Int32 = 1

    def next : Int32
      value = current_value

      self.current_value = next_value
      self.next_value = value + current_value

      value
    end
  end

  class RatioGenerator
    include Iterator(Float64)

    private getter sequence_generator = SequenceGenerator.new
    private property prev : Int32 = 0

    def next : Float64
      seq_val = sequence_generator.next
      ratio = seq_val / prev
      self.prev = seq_val
      ratio
    end
  end
end

if ARGV.size != 1
  STDERR.puts "Wrong number of arguments!"
  STDERR.puts "Usage: #{PROGRAM_NAME} <number of sequence elements>"
  exit(1)
end

element_count = ARGV[0].to_i

seq_gen = Fibo::SequenceGenerator.new
ratio_gen = Fibo::RatioGenerator.new

puts seq_gen.first(element_count).join(",")
puts ratio_gen.first(element_count).join(",")
