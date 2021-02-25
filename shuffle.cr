require "random"

def fisher_yates_category_preallocate(category_counts)
  shuffled = category_counts.flat_map { |(category, count)| [category] * count }
  (shuffled.size - 1).downto 1 do |i|
    shuffled.swap i, Random.rand(0..i)
  end
  shuffled
end

def fisher_yates_category_online(category_counts)
  categories = category_counts.keys
  total_count = category_counts.values.sum
  Array(String).build(capacity: total_count) do |buffer|
    buffer = buffer.to_slice total_count
    buffer.each_index do |i|
      j = Random.rand(0..i)
      unless i == j
        buffer[i] = buffer[j]
      end

      category = categories.find { |category| category_counts[category] > 0 }.not_nil!
      buffer[j] = category
      category_counts[category] -= 1
    end
    total_count
  end
end

category_counts = {"Lion" => 3, "Tiger" => 3, "Bear" => 4}

p! fisher_yates_category_preallocate category_counts
p! fisher_yates_category_online category_counts

def fisher_yates_inside_out(arr)
  gg
end

arr = ["Lion", "Tiger", "Bear", "Wolf", "Jaguar", "Lynx", "Bobcat", "Hyena", "Dingo"]

p! arr
p! fisher_yates_inside_out
p! arr
