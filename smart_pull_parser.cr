require "json"

abstract class Geometry
  def self.new(pull : JSON::PullParser)
    parsed = JSON::Any.new pull

    case parsed["type"]?
    when "point"
      Point.new parsed
    when "circle"
      Circle.new parsed
    when nil
      raise "Shouldn't be nil!"
    else
      raise "Unexpected something-or-other!"
    end
  end
end

class Point < Geometry
  include JSON::Serializable

  property x : Int32
  property y : Int32

  def initialize(parsed : JSON::Any)
    if x = parsed["x"]?
      @x = x.as_i
    else
      raise "Point must have an x!"
    end

    if y = parsed["y"]?
      @y = y.as_i
    else
      raise "Point must have a y!"
    end
  end
end

class Circle < Geometry
  include JSON::Serializable

  property center : Point
  property radius : Int32

  def initialize(parsed : JSON::Any)
    if center = parsed["center"]?
      @center = Point.new center
    else
      raise "Circle must have an x!"
    end

    if radius = parsed["radius"]?
      @radius = radius.as_i
    else
      raise "Circle must have a radius!"
    end
  end
end

module JSON
  annotation Discriminator
  end
end

input = <<-JSON
        [
          {
            "type": "point",
            "x": 1,
            "y": 2
          },
          {
            "type": "circle",
            "center": {
              "type": "point",
              "x": 5,
              "y": 0
            },
            "radius": 7
          }
        ]
        JSON

# puts input

output = Array(Geometry).from_json input

puts output
