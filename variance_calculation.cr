# this file is meant to demonstrate different algorithms for calculating
# statistical variance

def naive_variance(nums)
  square_of_sums = nums.sum ** 2
  sum_of_squares = nums.sum { |n| n**2 }
  (sum_of_squares - square_of_sums / nums.size) / (nums.size - 1)
end

def two_pass_variance(nums)
  mean = nums.sum { |n| n / nums.size }
  nums.sum { |n| (n - mean)**2 } / (nums.size - 1) # variance
end

def method_welford_online_variance(nums)
  count = 0
  mean = 0
  squared_distance_from_mean = 0

  nums.each do |num|
    count += 1
    delta = num - mean
    mean += delta / count
    delta2 = num - mean
    squared_distance_from_mean += delta * delta2
  end

  squared_distance_from_mean / (count - 1)
end

def struct_welford_online_variance(nums)
  nums.reduce(WelfordAggregate.new) { |agg, n| agg.update n }.finalize_variance
end

struct WelfordAggregate
  property count : Int32
  property mean : Float64
  property squared_distance_from_mean : Float64

  def initialize(@count = 0, @mean = 0.0, @squared_distance_from_mean = 0.0)
  end

  def update(num)
    count, mean, squared_distance_from_mean = self.count, self.mean, self.squared_distance_from_mean
    count += 1
    delta = num - mean
    mean += delta / count
    delta2 = num - mean
    squared_distance_from_mean += delta * delta2
    WelfordAggregate.new count, mean, squared_distance_from_mean
  end

  def finalize_variance
    squared_distance_from_mean / (count - 1)
  end
end
