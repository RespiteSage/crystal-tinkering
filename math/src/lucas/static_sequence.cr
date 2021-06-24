module Lucas
  # TODO
  abstract class StaticSequence(P, Q)
    include Iterator(Int32)

    # TODO
    class FirstKind(P, Q) < StaticSequence(P, Q)
      private property current_value : Int32 = 0
      private property next_value : Int32 = 1

      def next : Int32
        value = current_value

        self.current_value = next_value
        self.next_value = P * current_value - Q * value

        value
      end
    end

    # TODO
    class SecondKind(P, Q) < StaticSequence(P, Q)
      private property current_value : Int32 = 2
      private property next_value : Int32 = P

      def next : Int32
        value = current_value

        self.current_value = next_value
        self.next_value = P * current_value - Q * value

        value
      end
    end

    # TODO
    def current : Int32
      current_value
    end
  end
end
