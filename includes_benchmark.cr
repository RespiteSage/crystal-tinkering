require "benchmark"

module FileEndingCheck
  extend self

  ENDINGS_SET   = Set{"jpg", "jpeg", "png", "gif"}
  ENDINGS_ARRAY = ["jpg", "jpeg", "png", "gif"]
  ENDINGS_TUPLE = {"jpg", "jpeg", "png", "gif"}

  def is_image_constant_set(filename)
    ENDINGS_SET.includes? File.extname(filename)
  end

  def is_image_constant_array(filename)
    ENDINGS_ARRAY.includes? File.extname(filename)
  end

  def is_image_constant_tuple(filename)
    ENDINGS_TUPLE.includes? File.extname(filename)
  end

  def is_image_literal_set(filename)
    Set{"jpg", "jpeg", "png", "gif"}.includes? File.extname(filename)
  end

  def is_image_literal_array(filename)
    ["jpg", "jpeg", "png", "gif"].includes? File.extname(filename)
  end

  def is_image_literal_tuple(filename)
    {"jpg", "jpeg", "png", "gif"}.includes? File.extname(filename)
  end
end

module IncludesCheck
  extend self

  SET   = Set{"a", "b", "c", "d", "e"}
  ARRAY = ["a", "b", "c", "d", "e"]
  TUPLE = {"a", "b", "c", "d", "e"}

  def includes_constant_set(string)
    ENDINGS_SET.includes? string
  end

  def includes_constant_array(string)
    ENDINGS_ARRAY.includes? string
  end

  def includes_constant_tuple(string)
    ENDINGS_TUPLE.includes? string
  end

  def includes_literal_set(string)
    Set{"a", "b", "c", "d", "e"}.includes? string
  end

  def includes_literal_array(string)
    ["a", "b", "c", "d", "e"].includes? string
  end

  def includes_literal_tuple(string)
    {"a", "b", "c", "d", "e"}.includes? string
  end
end

include FileEndingCheck
include IncludesCheck

puts "Checking Image File Endings"
puts "---------------------------"

image_filename = "file.png"
puts "With an image filename:"
Benchmark.ips do |x|
  x.report("constant set (image)") { is_image_constant_set image_filename }
  x.report("constant array (image)") { is_image_constant_array image_filename }
  x.report("constant tuple (image)") { is_image_constant_tuple image_filename }
  x.report("literal set (image)") { is_image_literal_set image_filename }
  x.report("literal array (image)") { is_image_literal_array image_filename }
  x.report("literal tuple (image)") { is_image_literal_tuple image_filename }
end
puts ""

non_image_filename = "file.txt"
puts "With a non-image filename:"
Benchmark.ips do |x|
  x.report("constant set (non-image)") { is_image_constant_set non_image_filename }
  x.report("constant array (non-image)") { is_image_constant_array non_image_filename }
  x.report("constant tuple (non-image)") { is_image_constant_tuple non_image_filename }
  x.report("literal set (non-image)") { is_image_literal_set non_image_filename }
  x.report("literal array (non-image)") { is_image_literal_array non_image_filename }
  x.report("literal tuple (non-image)") { is_image_literal_tuple non_image_filename }
end

puts ""
puts ""
puts "Simple String Inclusion"
puts "------------------"

included_string = "d"
puts "With an string in the collection:"
Benchmark.ips do |x|
  x.report("constant set (image)") { includes_constant_set included_string }
  x.report("constant array (image)") { includes_constant_array included_string }
  x.report("constant tuple (image)") { includes_constant_tuple included_string }
  x.report("literal set (image)") { includes_literal_set included_string }
  x.report("literal array (image)") { includes_literal_array included_string }
  x.report("literal tuple (image)") { includes_literal_tuple included_string }
end
puts ""

non_included_string = "z"
puts "With a string missing from the collection"
Benchmark.ips do |x|
  x.report("constant set (non-image)") { includes_constant_set non_included_string }
  x.report("constant array (non-image)") { includes_constant_array non_included_string }
  x.report("constant tuple (non-image)") { includes_constant_tuple non_included_string }
  x.report("literal set (non-image)") { includes_literal_set non_included_string }
  x.report("literal array (non-image)") { includes_literal_array non_included_string }
  x.report("literal tuple (non-image)") { includes_literal_tuple non_included_string }
end
