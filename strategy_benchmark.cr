require "benchmark"

struct PositiveStrategy
  def call(value)
    value
  end
end

struct NegativeStrategy
  def call(value)
    value * -1
  end
end

struct MaybeNegativeStruct
  @caller : PositiveStrategy | NegativeStrategy
  @val : Int32

  def initialize(@flag : Bool)
    @caller = flag ? PositiveStrategy.new : NegativeStrategy.new
    @val = 10
  end

  def next
    @caller.call @val
  end
end

positive_struct = MaybeNegativeStruct.new true
negative_struct = MaybeNegativeStruct.new false

p! positive_struct.next
p! negative_struct.next

struct MaybeNegativeProc
  getter(caller : Proc(Int32)) { @flag ? ->foo : ->bar }
  @val : Int32

  def initialize(@flag : Bool)
    @val = 10
  end

  def next
    self.caller.call
  end

  def foo : Int32
    @val
  end

  def bar : Int32
    @val * -1
  end
end

positive_proc = MaybeNegativeProc.new true
negative_proc = MaybeNegativeProc.new false

p! positive_proc.next
p! negative_proc.next

outcome = 1
negative = false
Benchmark.ips do |x|
  negative = !negative
  mns = MaybeNegativeStruct.new negative
  mnp = MaybeNegativeProc.new negative

  x.report("Struct") do
    outcome &+= mns.next
  end

  x.report("Proc") do
    outcome &+= mnp.next
  end
end
