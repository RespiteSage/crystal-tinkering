class IteratorProduct(T, U)
  include Iterator(Tuple(T, U))

  private getter first : Iterator(T)
  private property second : Iterator(U)
  getter second_beginning : Iterator(U)

  private property first_current : T | Iterator::Stop

  def initialize(@first, second)
    @first_current = first.next
    @second_beginning = second
    @second = second_beginning.dup
  end

  def next
    if first_current.is_a? Iterator::Stop
      Iterator.stop
    else
      second_current = second.next

      if second_current.is_a? Iterator::Stop
        self.first_current = first.next
        self.second = second_beginning.dup
        self.next
      else
        unless (local_first_current = first_current).is_a? Iterator::Stop
          Tuple(T, U).new local_first_current, second_current
        else
          raise "Oops"
        end
      end
    end
  end
end

module Iterator(T)
  def product(other : Iterator(U)) forall U
    IteratorProduct(T, U).new self, other
  end
end

it = [1, 2, 3].each.product [4, 5, 6].each
p! it.join ","
