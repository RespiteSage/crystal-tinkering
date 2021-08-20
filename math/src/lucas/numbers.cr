require "./static_sequence"

module Lucas::Numbers
  alias Sequence = Lucas::StaticSequence::SecondKind(1, -1)

  def self.iterator : Lucas::Numbers::Sequence
    Lucas::Numbers::Sequence.new
  end
end
