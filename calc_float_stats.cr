require "./variance_calculation"

stats = WelfordAggregate.new

# TODO: handle STDIN or file

STDIN.each_line do |line|
  if (float = line.to_f)
    stats = stats.update(float)
  else
    puts "Warning: ignoring line '#{line}'"
  end
end

puts "Count: #{stats.count}"
puts "Mean: #{stats.mean}"
puts "Variance: #{stats.finalize_variance}"
puts "Std Dev: #{Math.sqrt(stats.finalize_variance)}"
