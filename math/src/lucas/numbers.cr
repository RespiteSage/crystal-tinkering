require "./sequence"

module Lucas::Numbers
  alias Sequence = Lucas::Sequence::SecondKind(1, -1)

  def self.iterator : Lucas::Numbers::Sequence
    Lucas::Numbers::Sequence.new
  end

  class RatioIterator
    include Iterator(Float64)

    private getter sequence
    private property prev : Int32 = 0

    def initialize(@sequence = Lucas::Numbers.iterator)
    end

    def next : Float64
      seq_val = sequence.next
      ratio = seq_val / prev
      self.prev = seq_val
      ratio
    end
  end
end
