require "benchmark"

MIN_SIZE = 2

def tokenize_baseline(string : String)
  tokens = string.split(/[\p{S}\p{N}\p{P}\p{C}\p{Z}]+/)

  groupings = [] of String
  tokens.each do |token|
    token.chars.each_cons(MIN_SIZE) do |cons|
      groupings << cons.join.downcase
    end
  end

  groupings.reject(&.empty?)
end

def tokenize_split_block(string : String)
  groupings = [] of String
  string.split(/[\p{S}\p{N}\p{P}\p{C}\p{Z}]+/, remove_empty: true) do |token|
    token.chars.each_cons(MIN_SIZE) do |cons|
      groupings << cons.join.downcase
    end
  end
  groupings
end

def tokenize_asterite_improved(string : String)
  groupings = [] of String

  string.split(/[\p{S}\p{N}\p{P}\p{C}\p{Z}]+/) do |token|
    next if token.empty?

    i = 0
    reader = Char::Reader.new(string)
    size = token.size
    while i <= size - MIN_SIZE
      pos = reader.pos
      reader.next_char
      next_pos = reader.pos
      (MIN_SIZE - 1).times do
        reader.next_char
      end

      grouping = token.byte_slice(pos, reader.pos - pos)
      grouping = grouping.downcase unless downcase?(grouping)
      groupings << grouping unless grouping.empty?

      reader.pos = next_pos
      i += 1
    end
  end

  groupings
end

def downcase?(string)
  string.each_char do |char|
    return false unless char.downcase == char
  end
  true
end

def tokenize_char_reader(string : String)
  frame_index = 0
  frame = Array(Char).new(MIN_SIZE)

  cReader = Char::Reader.new(string)

  groupings = Array(String).new
  cReader.each do |current_char|
    if current_char.to_s =~ /[\p{S}\p{N}\p{P}\p{C}\p{Z}]/
      frame.clear
    else
      unless (frame.size < MIN_SIZE)
        frame.shift
      end

      frame << current_char

      unless (frame.size < MIN_SIZE)
        groupings << frame.join.downcase
      end
    end
  end
  groupings
end

class TokenizationFrame
  private getter frame_size : Int32
  private property current_size = 0
  private getter chars : Slice(Char)
  private property current_index = 0

  def initialize(size)
    @chars = Slice(Char).new(size, value: ' ')
    @frame_size = size
  end

  def <<(char : Char)
    chars[current_index] = char

    unless full?
      self.current_size += 1
    end

    self.current_index = next_index current_index
  end

  def full?
    current_size == frame_size
  end

  def join
    String.build(capacity: frame_size) do |builder|
      index = self.current_index
      frame_size.times do
        builder << chars[index]
        index = next_index index
      end
    end
  end

  def reset
    self.current_size = 0
    self.current_index = 0
  end

  private def next_index(index)
    (index + 1) % frame_size
  end
end

def tokenize_char_reader_with_class(string : String)
  frame = TokenizationFrame.new(MIN_SIZE)

  cReader = Char::Reader.new(string)

  groupings = Array(String).new
  cReader.each do |current_char|
    if current_char.to_s =~ /[\p{S}\p{N}\p{P}\p{C}\p{Z}]/
      frame.reset
    else
      frame << current_char

      if frame.full?
        groupings << frame.join.downcase
      end
    end
  end
  groupings
end

test_string = "This is something to tokenize, and I will tokenize it."

method_results = Hash(String, Array(String)).new
method_results["baseline"] = tokenize_baseline(test_string)
method_results["split_block"] = tokenize_split_block(test_string)
method_results["char_reader"] = tokenize_char_reader(test_string)
method_results["char_reader_with_class"] = tokenize_char_reader_with_class(test_string)
method_results["asterite_improved"] = tokenize_asterite_improved(test_string)

puts "Baseline matching verification:"
baseline_output = method_results["baseline"]
method_results.each do |(method, result)|
  same = method_results[method] == baseline_output

  puts "#{method} #{(same) ? "matches" : "does not match"} the baseline result"
end

puts "", "Benchmarking:"

Benchmark.ips do |x|
  x.report("baseline") { tokenize_baseline(test_string) }
  x.report("split_block") { tokenize_split_block(test_string) }
  x.report("char_reader") { tokenize_char_reader(test_string) }
  x.report("char_reader_with_class") { tokenize_char_reader_with_class(test_string) }
  x.report("asterite_improved") { tokenize_asterite_improved(test_string) }
end
