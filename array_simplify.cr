require "benchmark"

def simplify(arr1, arr2)
  arr1 = arr1.sort
  arr2 = arr2.sort

  index1 = 0
  index2 = 0
  until (index1 == arr1.size) || (index2 == arr2.size)
    if arr1[index1] == arr2[index2]
      arr1.delete_at index1
      arr2.delete_at index2
    else
      if arr2[index2] > arr1[index1]
        index1 += 1
      else
        index2 += 1
      end
    end
  end

  {arr1, arr2}
end

def simplify_nowhile(arr1, arr2)
  arr1 = arr1.dup
  arr2 = arr2.dup

  deletion_indices1 = Array(Int32).new
  arr1.each_with_index do |e1, index1|
    deletion_indices2 = Array(Int32).new
    arr2.each_with_index do |e2, index2|
      if (e1 == e2)
        deletion_indices1 << index1
        deletion_indices2 << index2
        break
      end
    end
    deletion_indices2.reverse_each { |index| arr2.delete_at index }
  end

  deletion_indices1.reverse_each { |index| arr1.delete_at index }

  {arr1, arr2}
end

def simplify_macrocompat(arr1, arr2)
  deletion_indices1 = Array(Int32).new
  arr1.each_with_index do |e1, index1|
    deletion_indices2 = Array(Int32).new
    marked_for_deletion = false
    arr2.each_with_index do |e2, index2|
      if !marked_for_deletion && (e1 == e2)
        deletion_indices1 << index1
        deletion_indices2 << index2
        marked_for_deletion = true
      end
    end

    # note that the Nil below needs to be changed to NilLiteral in actual macros
    arr2 = arr2.map_with_index { |element, index| (deletion_indices2.includes? index) ? nil : element }.reject { |element| element.is_a? Nil }
  end

  arr1 = arr1.map_with_index { |element, index| (deletion_indices1.includes? index) ? nil : element }.reject { |element| element.is_a? Nil }

  {arr1, arr2}
end

a = ["x", "v", "z", "x", "y"]
b = ["u", "x", "z", "z"]

p! a
p! b

p! simplify a, b
p! a
p! b

p! simplify_nowhile a, b
p! a
p! b

p! simplify_macrocompat a, b
p! a
p! b

puts ""

Benchmark.ips do |x|
  x.report("while") do
    simplify ["x", "v", "z", "x", "y"], ["u", "x", "z", "z"]
  end
  x.report("no while") do
    simplify_nowhile ["x", "v", "z", "x", "y"], ["u", "x", "z", "z"]
  end
  x.report("macro-compatible") do
    simplify_macrocompat ["x", "v", "z", "x", "y"], ["u", "x", "z", "z"]
  end
end
