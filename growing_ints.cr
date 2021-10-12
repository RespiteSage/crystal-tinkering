require "big"
require "time"

max = BigInt.new(Int128::MAX)
max * 2
increasing_size_ints = {Int8, Int16, Int32, Int64, BigInt}

n = 1i8

# growing ints
n_time = Time.measure do
  while n < max
    begin
      n *= 2
    rescue
      new_type = increasing_size_ints[increasing_size_ints.index(n.class).not_nil! + 1]
      n = new_type.new(n)
      n *= 2
    end
  end
end

m = BigInt.new(1)

# big_int
m_time = Time.measure do
  while m < max
    m *= 2
  end
end

p! n, n_time
p! m, m_time
