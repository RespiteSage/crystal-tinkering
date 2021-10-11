# this file is meant to compare different algorithms for calculating
# statistical variance

require "benchmark"

require "./variance_calculation"

puts "Expected variance for [4, 7, 13, 16]: 30.0"
p! naive_variance([4_f64, 7_f64, 13_f64, 16_f64])
p! two_pass_variance([4_f64, 7_f64, 13_f64, 16_f64])
p! method_welford_online_variance([4_f64, 7_f64, 13_f64, 16_f64])
p! struct_welford_online_variance([4_f64, 7_f64, 13_f64, 16_f64])
puts ""

a = 0

Benchmark.ips do |x|
  arr = Array(Int64).new(100000) { |i| (i * 7 % 17).to_i64 }

  x.report("naive_variance") do
    a *= naive_variance(arr).sign
  end

  x.report("two_pass_variance") do
    a *= two_pass_variance(arr).sign
  end

  x.report("method_welford_online_variance") do
    a *= method_welford_online_variance(arr).sign
  end

  x.report("struct_welford_online_variance") do
    a *= struct_welford_online_variance(arr).sign
  end
end
