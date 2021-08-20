require "../ratioable"

module Lucas
  # TODO
  abstract class Sequence
    include Iterator(Int32)

    # TODO
    class FirstKind < Sequence
      include Ratioable

      private property current_value : Int32 = 0
      private property next_value : Int32 = 1

      getter p : Int32
      getter q : Int32

      def initialize(@p, @q)
      end

      def next : Int32
        value = current_value

        self.current_value = next_value
        self.next_value = p * current_value - q * value

        value
      end
    end

    # TODO
    class SecondKind < Sequence
      include Ratioable

      private property current_value : Int32 = 2
      private property next_value : Int32

      getter p : Int32
      getter q : Int32

      def initialize(@p, @q)
        @next_value = p
      end

      def next : Int32
        value = current_value

        self.current_value = next_value
        self.next_value = p * current_value - q * value

        value
      end
    end

    # TODO
    def current : Int32
      current_value
    end
  end
end
