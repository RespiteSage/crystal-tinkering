module LLVM
  @[Link(ldflags: "-lLLVM")]
  # TODO
  lib LibFixedPoint
    fun mul_i32 = "llvm.smul.fix.i32"(first : Int32, second : Int32, scale : Int32) : Int32
    fun div_i32 = "llvm.sdiv.fix.i32"(first : Int32, second : Int32, scale : Int32) : Int32
  end
end

struct FixedPointExample
  SCALE = 1024i32
  getter underlying : Int32

  def initialize(float_value)
    @underlying = (float_value * SCALE).to_i32
  end

  def initialize(*, @underlying)
  end

  def to_f64
    underlying / SCALE
  end

  def +(other)
    FixedPointExample.new(underlying: underlying + other.underlying)
  end

  def -(other)
    FixedPointExample.new(underlying: underlying - other.underlying)
  end

  def *(other)
    multiply_simple other
  end

  def multiply_simple(other)
    FixedPointExample.new(underlying: (underlying * other.underlying) // SCALE)
  end

  def multiply_bound(other)
    FixedPointExample.new(underlying: LLVM::LibFixedPoint.mul_i32(underlying, other.underlying, 10))
  end

  def **(other)
    exp_powermult other
  end

  def exp_powermult(other)
    exp = other.underlying / SCALE
    underlying_component = underlying ** exp
    scale_component = SCALE ** (1 - exp)
    FixedPointExample.new(underlying: (underlying_component * scale_component).to_i32)
  end

  def exp_divpowermult(other)
    exp = other.underlying / SCALE
    power_result = (underlying / SCALE) ** exp
    FixedPointExample.new(underlying: (SCALE * power_result).to_i)
  end
end

first = FixedPointExample.new(2.5)
second = FixedPointExample.new(2)

p! first.to_f64
p! second.to_f64
p! (first + second).to_f64
p! (first - second).to_f64
p! (first * second).to_f64
p! (first.multiply_bound second).to_f64

p! (first.exp_powermult second).to_f64
p! (first.exp_divpowermult second).to_f64

puts ""

# require "benchmark"

# bench_first = FixedPointExample.new(2.5)
# bench_second = FixedPointExample.new(2)

# trash = 0f64

# puts "2.5 ** 2"
# puts "--------"
# Benchmark.ips do |x|
#   x.report("32-bit integer multiply") do
#     result = 2.5 * 2
#     trash += result
#   end

#   {% for method_name in ["multiply_simple", "multiply_bound"] %}
#     x.report("{{method_name.id}}") do
#       result = bench_first.{{method_name.id}} bench_second
#       trash += result.underlying
#     end
#   {% end %}
# end
# puts ""

# trash = 0f64

# puts "2.5 ** 2"
# puts "--------"
# Benchmark.ips do |x|
#   x.report("32-bit floating-point exp") do
#     result = 2.5 ** 2
#     trash += result
#   end

#   {% for method_name in ["exp_powermult", "exp_divpowermult"] %}
#     x.report("{{method_name.id}}") do
#       result = bench_first.{{method_name.id}} bench_second
#       trash += result.underlying
#     end
#   {% end %}
# end
# puts ""

# trash = 0f64

# puts "2 ** 2.5"
# puts "--------"
# Benchmark.ips do |x|
#   x.report("32-bit floating-point exp") do
#     result = 2 ** 2.5
#     trash += result
#   end

#   {% for method_name in ["exp_powermult", "exp_divpowermult"] %}
#     x.report("{{method_name.id}}") do
#       result = bench_second.{{method_name.id}} bench_first
#       trash += result.underlying
#     end
#   {% end %}
# end
# puts ""
