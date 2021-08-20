require "../ratioable"

module Phi
  class Sequence
    include Iterator(Int32)
    include Ratioable

    private property current_value : Int32
    private property next_value : Int32

    def initialize(@current_value = 0, @next_value = 1)
    end

    def next : Int32
      value = current_value

      self.current_value = next_value
      self.next_value = current_value + value

      value
    end
  end
end
