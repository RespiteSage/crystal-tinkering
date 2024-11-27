require "math"

# TODO
def logit(p : Float)
  Math.log(p / (1 - p))
end

# TODO
def standard_logistic_function(x : Float)
  1 / (1 + Math.exp(-x))
end

# TODO
class LogOdds
  getter log_odds : Float64

  # TODO
  def initialize(@log_odds : Float)
  end

  # TODO
  def self.from_odds(odds : Float)
    new(Math.log odds)
  end

  # TODO
  def self.from_probability(p : Float)
    new(logit p)
  end

  # TODO
  def odds
    Math.exp log_odds
  end

  # TODO
  def probability
    standard_logistic_function log_odds
  end

  # TODO
end
