require "./variance_calculation"

# based on WelfordAggregate in variance_calculation.cr
class RunningStats
  property count : Int32
  property mean : Float64
  property squared_distance_from_mean : Float64
  property min : Float64
  property max : Float64

  def initialize(@count = 0, @mean = 0.0, @squared_distance_from_mean = 0.0, @min = 0.0, @max = 0.0)
  end

  def update(num)
    count, mean, squared_distance_from_mean = self.count, self.mean, self.squared_distance_from_mean
    count += 1
    delta = num - mean
    mean += delta / count
    delta2 = num - mean
    squared_distance_from_mean += delta * delta2

    self.count = count
    self.mean = mean
    self.squared_distance_from_mean = squared_distance_from_mean
    self.min = {self.min, num}.min
    self.max = {self.max, num}.max
  end

  def finalize_variance
    squared_distance_from_mean / (count - 1)
  end
end

stats = RunningStats.new

# TODO: handle STDIN or file

STDIN.each_line do |line|
  if (float = line.to_f)
    stats.update(float)
  else
    puts "Warning: ignoring line '#{line}'"
  end
end

puts "Count: #{stats.count}"
puts "Min: #{stats.min}"
puts "Max: #{stats.max}"
puts "Mean: #{stats.mean}"
puts "Variance: #{stats.finalize_variance}"
puts "Std Dev: #{Math.sqrt(stats.finalize_variance)}"
