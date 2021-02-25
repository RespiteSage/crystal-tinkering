abstract struct Number
  def saturating_add(other : Number) : self
    if other < 0
      saturating_subtract (-other)
    else
      begin
        self + other
      rescue OverflowError
        MAX
      end
    end
  end

  def saturating_subtract(other : Number) : self
    if other < 0
      self + (-other)
    else
      begin
        self - other
      rescue OverflowError
        MIN
      end
    end
  end

  def saturating_multiply(other : Number) : self
    begin
      self * other
    rescue OverflowError
      if (self < 0) ^ (other < 0) # this does cancelling of negative signs
        MIN
      else
        MAX
      end
    end
  end
end

p! 7_u8.saturating_subtract 8
p! 255_u8.saturating_add 2
p! 7_u8.saturating_multiply 100
