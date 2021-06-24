# TODO
class CircularBuffer(T, N)
  include Indexable(T)

  private getter buffer : StaticArray(T, N)
  private property first_index : Int32 = 0

  private def increment_first_index
    self.first_index = (first_index < N - 1) ? first_index + 1 : 0
  end

  private def decrement_first_index
    self.first_index = (first_index > 0) ? first_index - 1 : N - 1
  end

  # Creates a new circular buffer and invokes the
  # block once for each index of the buffer, assigning the
  # block's value in that index.
  #
  # ```
  # CircularBuffer(Int32, 3).new { |i| i * 2 } # => CircularBuffer[0, 2, 4]
  # ```
  def initialize(&block : Int32 -> T)
    @buffer = StaticArray(T, N).new(block)
  end

  # Creates a new circular buffer filled with the given value.
  #
  # ```
  # CircularBuffer(Int32, 3).new(42) # => CircularBuffer[42, 42, 42]
  # ```
  def initialize(value : T)
    @buffer = StaticArray(T, N).new(value)
  end

  # :inherit:
  def unsafe_fetch(index : Int)
    index = (index - first_index) % N
    buffer.unsafe_fetch index
  end

  # :inherit:
  def size
    N
  end

  # TODO: not really a normal pop because it goes to the end
  def pop : T
    increment_first_index
    last
  end
end
