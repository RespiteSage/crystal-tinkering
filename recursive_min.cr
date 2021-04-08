# testing different nested min implementations

def recursive_min_flatten(arr)
  arr.flatten.min
end

def recursive_min_iterator(arr)
  arr.each.flatten.min
end

def paired_recursive_min(arr : Array)
  arr.min
end

def paired_recursive_min(arr : Array(Array))
  arr.min_of { |internal_arr| paired_recursive_min internal_arr }
end

require "benchmark"

# to try and manipulate the compiler into using all the benchmark code
min = 0

# 1D

puts "Benchmarking 1D array min"
Benchmark.ips do |x|
  one_d = Array.new(1_000_000) { (1..1000).sample }

  x.report("Array#min") do
    min = one_d.min
  end

  x.report("recursive_min_flatten") do
    min = recursive_min_flatten one_d
  end

  x.report("recursive_min_iterator") do
    min = recursive_min_iterator one_d
  end

  x.report("paired_recursive_min") do
    min = paired_recursive_min one_d
  end
end
puts "---\n"

puts "Benchmarking 2D array min"
Benchmark.ips do |x|
  two_d = Array.new(1_000) { Array.new(1_000) { (1..1000).sample } }

  x.report("Array#min_of(&.min)") do
    min = two_d.min_of(&.min)
  end

  x.report("recursive_min_flatten") do
    min = recursive_min_flatten two_d
  end

  x.report("recursive_min_iterator") do
    min = recursive_min_iterator two_d
  end

  x.report("paired_recursive_min") do
    min = paired_recursive_min two_d
  end
end
puts "---\n"

puts "Benchmarking 3D array min"
Benchmark.ips do |x|
  three_d = Array.new(100) { Array.new(100) { Array.new(100) { (1..1000).sample } } }

  x.report("Array#min_of(&.min_of(&.min))") do
    min = three_d.min_of(&.min_of(&.min))
  end

  x.report("recursive_min_flatten") do
    min = recursive_min_flatten three_d
  end

  x.report("recursive_min_iterator") do
    min = recursive_min_iterator three_d
  end

  x.report("paired_recursive_min") do
    min = paired_recursive_min three_d
  end
end
