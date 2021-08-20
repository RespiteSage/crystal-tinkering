module Ratioable
  macro included
    class RatioGenerator
      include Iterator(Float64)

      private getter sequence_generator : Iterator(Int32)
      private property prev : Int32 = 0

      def initialize(@sequence_generator)
      end

      def next : Float64
        seq_val = sequence_generator.next.as(Int32)
        ratio = seq_val / prev
        self.prev = seq_val
        ratio
      end
    end

    # TODO
    # Note: the returned iterator will modify its enclosed sequence iterator
    def ratios
      RatioGenerator.new(self)
    end

    def self.ratios
      RatioGenerator.new(new())
    end
  end
end
