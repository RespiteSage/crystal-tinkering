require "benchmark"

macro oneDNext_macro
  @last_index = @next_index
  @next_index += @strides[@ndims - 1]
  if @next_index > @size
    return stop
  end
  @last_index
end

macro nDNext_macro
  if @done
    return stop
  end

  u = @ndims - 1
  ni = @next_index
  @last_index = ni

  u.step(to: 0, by: -1) do |i|
    @track[i] += 1
    shape_i = @shape[i]
    stride_i = @strides[i]

    if @track[i] == shape_i
      if i == 0
        @done = true
      end
      @track[i] = 0
      ni -= (shape_i - 1) * stride_i
      next
    end
    ni += stride_i
    break
  end

  @next_index = ni
  @last_index
end

module NDIter
  include Iterator(UInt64)

  @track : Pointer(UInt64)
  @shape : Pointer(UInt64)
  @strides : Pointer(UInt64)
  @ndims : Int32
  @next_index : UInt64
  @last_index : UInt64
  @done : Bool = false
  @contiguous : Bool
  @size : Int32

  def initialize(shape : Array(Int32), strides : Array(Int32), @contiguous : Bool)
    @ndims = shape.size
    @size = shape.reduce { |i, j| i * j } * strides[-1]
    @track = Pointer(UInt64).malloc(@ndims, UInt64.new(0))
    @shape = Pointer(UInt64).malloc(@ndims) { |i| UInt64.new(shape[i]) }
    @strides = Pointer(UInt64).malloc(@ndims) { |i| UInt64.new(strides[i]) }
    @next_index = 0
    @last_index = 0
  end

  def rewind
    @done = false
    @last_index = 0
    @next_index = 0
  end

  abstract def next
end

struct IterFast
  include NDIter

  def next
    if @contiguous
      oneDNext_macro
    else
      nDNext_macro
    end
  end
end

struct IterStrategy
  struct OneD
    include NDIter

    def next
      oneDNext_macro
    end
  end

  struct ND
    include NDIter

    def next
      nDNext_macro
    end
  end

  def initialize(shape : Array(Int32), strides : Array(Int32), contiguous : Bool)
    @strategy = (contiguous) ? OneD.new(shape, strides, contiguous) : ND.new(shape, strides, contiguous)
  end

  forward_missing_to @strategy
end

struct IterProc
  include NDIter

  getter(caller : Proc(UInt64 | Iterator::Stop)) { @contiguous ? ->onednext : ->ndnext }

  def next
    self.caller.call
  end

  def onednext
    oneDNext_macro
  end

  def ndnext
    nDNext_macro
  end
end

struct IterOneD
  include NDIter

  def next
    oneDNext_macro
  end
end

struct IterND
  include NDIter

  def next
    nDNext_macro
  end
end

a = 1

puts "Contiguous"
puts "-----"
Benchmark.ips do |b|
  b.report("IterFast") do
    t = IterFast.new([100, 100, 100], [10000, 100, 1], true)
    t.each { |i| a &+= i }
  end

  b.report("IterStrategy") do
    t = IterStrategy.new([100, 100, 100], [10000, 100, 1], true)
    t.each { |i| a &+= i }
  end

  b.report("IterProc") do
    t = IterProc.new([100, 100, 100], [10000, 100, 1], true)
    t.each { |i| a &+= i }
  end

  b.report("IterOneD") do
    t = IterOneD.new([100, 100, 100], [10000, 100, 1], true)
    t.each { |i| a &+= i }
  end
end

puts ""
puts "ND"
puts "-----"
Benchmark.ips do |b|
  b.report("IterFast") do
    t = IterFast.new([100, 100, 100], [10000, 100, 1], false)
    t.each { |i| a &+= i }
  end

  b.report("IterStrategy") do
    t = IterStrategy.new([100, 100, 100], [10000, 100, 1], false)
    t.each { |i| a &+= i }
  end

  b.report("IterProc") do
    t = IterProc.new([100, 100, 100], [10000, 100, 1], false)
    t.each { |i| a &+= i }
  end

  b.report("IterND") do
    t = IterND.new([100, 100, 100], [10000, 100, 1], false)
    t.each { |i| a &+= i }
  end
end
