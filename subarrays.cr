require "benchmark"

module First
  def self.contains(array : Array(T), other : Array(T)) forall T
    (0..(array.size - other.size)).each do |index|
      if array[index, other.size] == other
        return true
      end
    end
    false
  end
end

module Second
  def self.contains(array : Array(T), other : Array(T)) forall T
    array.each_index(start: 0, count: 1 + array.size - other.size) do |index|
      if contains(array, other, index)
        return true
      end
    end
    false
  end

  private def self.contains(array : Array(T), other : Array(T), at index : Int32) forall T
    other.each_index do |subindex|
      if array[index + subindex] != other[subindex]
        return false
      end
    end
    true
  end
end

module Third
  def self.contains(array : Array(T), other : Array(T)) forall T
    array.each_index do |index|
      if contains(array, other, index)
        return true
      end
    end
    false
  end

  private def self.contains(array : Array(T), other : Array(T), at index : Int32) forall T
    other.each_index do |subindex|
      if array[index + subindex]? && array[index + subindex] != other[subindex]
        return false
      end
    end
    true
  end
end

module Fourth
  def self.contains(array : Array(T), other : Array(T)) forall T
      left = array.to_unsafe
      right = other.to_unsafe
      window_size = other.size
      max_index = array.size - window_size

      return false if max_index < 0

      0.upto(max_index) do |index|
        diff = right.memcmp(left + index, window_size)
        return true if diff.zero?
      end

      false
    end
end

array_a = [1,2,3,4,5]
array_b = [3,4,5]
array_c = [1,3,5]
array_d = [2,1,3]

Benchmark.ips do |bm|
  bm.report("creating subarrays") do
    First.contains(array_a, array_b)
    First.contains(array_a, array_c)
    First.contains(array_a, array_d)
  end

  bm.report("iterative equality check") do
    Second.contains(array_a, array_b)
    Second.contains(array_a, array_c)
    Second.contains(array_a, array_d)
  end

  bm.report("iterative equality check to end") do
    Third.contains(array_a, array_b)
    Third.contains(array_a, array_c)
    Third.contains(array_a, array_d)
  end

  bm.report("memcmp") do
    Fourth.contains(array_a, array_b)
    Fourth.contains(array_a, array_c)
    Fourth.contains(array_a, array_d)
  end
end
