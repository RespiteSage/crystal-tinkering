require "benchmark"

def proper_latitude_current(latitude)
  if latitude > Math::PI / 2
    Math::PI - latitude
  elsif latitude < -Math::PI / 2
    -Math::PI - latitude
  else
    latitude
  end
end

def wrap_angle(angle, range_bottom, range_top)
  wrapped_angle = (angle - range_bottom) % (range_top - range_bottom)
  wrapped_angle += range_bottom
  if wrapped_angle == range_bottom && angle >= range_top
    range_top
  elsif wrapped_angle == range_top && angle <= range_bottom
    range_bottom
  else
    wrapped_angle
  end
end

def proper_latitude_wrapped(latitude)
  wrap_angle(latitude, -Math::PI / 2, Math::PI / 2)
end

(-6..6).map { |n| {n, n * Math::PI / 6} }.each do |(n, value)|
  puts ""
  puts "Proper Angle of #{n} * PI / 6"

  Benchmark.ips do |x|
    x.report("current_impl") do
      proper_latitude_current(value)
    end

    x.report("wrapping_impl") do
      proper_latitude_wrapped(value)
    end
  end
end
