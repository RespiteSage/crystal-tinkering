module Fibo
  class SequenceGenerator
    include Iterator(Int32)

    private property index = 0
    private property prev_prev : Int32 = 0
    private property prev : Int32 = 1

    def next : Int32
      if index == 0
        self.index += 1
        return prev_prev
      end

      if index == 1
        self.index += 1
        return prev
      end

      self.index += 1

      value = prev_prev + prev

      self.prev_prev = prev
      self.prev = value

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
