class MonthIterator
  include Iterator(Time)

  property time : Time

  def initialize(@time)
  end

  def next
    time_result = self.time
    self.time += 1.month
    time_result
  end
end
