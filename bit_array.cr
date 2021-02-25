require "bit_array"

struct BitArray
  def self.new(size, & : Int32 -> Bool)
    instance = BitArray.new(size)
    (0...size).each do |i|
      instance[i] = yield i
    end
    instance
  end
end

RANDOM = Random.new

ba = BitArray.new(12) { |i| RANDOM.next_bool }
pp ba
