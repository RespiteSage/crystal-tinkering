require "benchmark"
require "bit_array"
require "intrinsics"

struct BitArray
  def self.new(size, & : Int32 -> Bool)
    instance = BitArray.new(size)
    (0...size).each do |i|
      instance[i] = yield i
    end
    instance
  end

  def fill_override(value : Bool) : self
    @bits.to_slice(malloc_size).fill (value ? ~0u32 : 0u32)
    self
  end

  def fill_override_intrinsics(value : Bool) : self
    Intrinsics.memset(@bits, (value ? ~0u8 : 0u8), bytesize, false)
    clear_unused_bits
    self
  end

  def fill_override_intrinsics_bitwise(value : Bool) : self
    Intrinsics.memset(@bits, (value.to_unsafe << 8), bytesize, false)
    clear_unused_bits
    self
  end
end

RANDOM = Random.new

1000.upto(1000) do |n|
  guide = BitArray.new(n) { |i| RANDOM.next_bool }
  start = BitArray.new(n) { |i| RANDOM.next_bool }
  puts "#{n}:"
  Benchmark.ips do |x|
    {% for method in ["fill", "fill_override", "fill_override_intrinsics", "fill_override_intrinsics_bitwise"] %}
    test = start.dup

    x.report({{method}}) do
      guide.each { |value| test.{{method.id}} value }
    end

    test = start.dup

    x.report("{{method.id}}_only_true") do
      guide.size.times { test.{{method.id}} true }
    end

    test = start.dup

    x.report("{{method.id}}_only_false") do
      guide.size.times { test.{{method.id}} false }
    end
    {% end %}
  end
  puts ""
end
