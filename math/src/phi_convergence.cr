require "./lucas/sequence"
require "./lucas/numbers"
require "./phi/fibo_generator"
require "./phi/sequence"

PHI = 1.618033988749894

generators = {
  "fibo"       => Fibo::SequenceGenerator.ratios,
  "lucas"      => Lucas::Numbers::Sequence.ratios,
  "three_five" => Phi::Sequence.new(3, 5).ratios,
  "one_two"    => Phi::Sequence.new(1, 2).ratios,
  "five_three" => Phi::Sequence.new(5, 3).ratios,
}

max_name_length = generators.max_of { |(key, _)| key.size }

1.upto(20) do |iteration|
  puts "Iteration #{iteration}"
  puts "------------"

  generators.each do |(name, gen)|
    abs_diff = (PHI - gen.next).abs
    name_column = "#{name}:".ljust(max_name_length + 1)
    puts "#{name_column} #{abs_diff}"
  end

  puts ""
end
