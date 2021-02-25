class DerivedUnit(N, D)
  def self.simplify
    {% begin %}
      {% numerator_types = N.type_vars.first.type_vars.map(&.id) %}
      {% denominator_types = D.type_vars.first.type_vars.map(&.id) %}
      {%
        num_deletion_indices = [] of Int32
        numerator_types.each_with_index do |num_element, num_index|
          den_deletion_indices = [] of Int32
          marked_for_deletion = false
          denominator_types.each_with_index do |den_element, den_index|
            if (num_element == den_element) && !marked_for_deletion
              num_deletion_indices << num_index
              den_deletion_indices << den_index
              # can't break, can't return...
              marked_for_deletion = true
            end
          end

          # deletion
          denominator_types = denominator_types.map_with_index { |element, index|
            if den_deletion_indices.includes? index
              nil
            else
              element
            end
          }.reject { |element| element.is_a? NilLiteral }
        end

        # deletion
        numerator_types = numerator_types.map_with_index { |element, index|
          if num_deletion_indices.includes? index
            nil
          else
            element
          end
        }.reject { |element| element.is_a? NilLiteral }
      %}

      {% numerator_types << 1 if numerator_types.empty? %}
      {% denominator_types << 1 if denominator_types.empty? %}

      DerivedUnit(UnitProduct({{numerator_types.splat}}),UnitProduct({{denominator_types.splat}}))
    {% end %}
  end
end

class UnitProduct(*T)
  def self.*(other : UnitProduct(*U).class) forall U
    {% begin %}
      UnitProduct(*{{ T + U.type_vars }})
    {% end %}
  end

  def self.//(other : UnitProduct(*U).class) forall U
    DerivedUnit(UnitProduct(*T), UnitProduct(*U)).simplify
  end

  def self.multiplicands
    Tuple.new(*{{T}})
  end
end

class Length
end

class Mass
end

alias Timespan = ::Time::Span

p! UnitProduct(Length, Mass).multiplicands

p! (UnitProduct(Length, Mass) * UnitProduct(Timespan, Timespan)).multiplicands

p! UnitProduct(Length, Timespan) // UnitProduct(Timespan, Timespan)
