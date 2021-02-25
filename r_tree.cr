require "math"

class RTree(K,V)
  class Node(K,V) < RTree(K,V)
    property minimum : K
    property maximum : K
    private getter min_children : Int32
    private getter max_children : Int32
    private getter children : Array(Node) | Hash(K,V)
    property distance_function : K, K -> Float64 = ->(first : K, second : K) { Math.abs first, second }

    def initialize(@minimum, @maximum, @min_children = 12, @max_children = 32)
      @children = Hash(K,V).new
    end

    def minimum
      self.minimum
    end

    def maximum
      self.maximum
    end

    def []=(key : K, value : V)
      if children.is_a? Hash(K,V)
        children[key] = value
      else
        # TODO: add method of using different (and user-defined) heuristics for insertion
        chosen_child = children.min_by { |child| (child.minimum - key) + (child.maximum - key) }
        chosen_child[key] = value
      end

      if children.size > max_children
        split
      end

      self
    end

    private def split
        # TODO: add method of using different (and user-defined) heuristics for splitting
        new_children = Array(Node).new

        # TODO
    end

    private def encompass(key : K)
      if key < minimum
        self.minimum = key
      end

      if key > maximum
        self.maximum = key
      end
    end

    def [](key : K) : V?
    end

    def delete(key : K)
    end
  end

  getter root : Node

  def initialize
  end
end
