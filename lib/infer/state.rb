module Infer

  Derivation = Struct.new(:parents, :rule, :conclusions) do
    def in_state(state)
      parents  = self.parents.map { |d| d.in_state(state) }
      conclude = self.conclusions.map { |expr| state.walk(expr) }
      Derivation.new(parents, rule, conclude)
    end
  end

  State = Struct.new(:values, :derivation) do
    def assign(var, value)
      State.new(values.merge(var => value), derivation)
    end

    def clear
      State.new(values)
    end

    def connect(state)
      State.new(values, state.parents + [derivation])
    end

    def derive(rule, conclusions)
      State.new(values, Derivation.new(parents, rule, conclusions))
    end

    def parents
      case derivation
      when NilClass   then []
      when Derivation then [derivation]
      when Array      then derivation
      end
    end

    def build_derivation
      derivation.in_state(self)
    end

    def walk(value)
      if values.has_key?(value)
        walk(values[value])
      elsif value.is_a?(Sequence)
        Sequence.new(value.map { |v| walk(v) })
      else
        value
      end
    end

    def unify(x, y)
      x, y = walk(x), walk(y)

      return self if x == y

      return assign(x, y) if x.is_a?(Variable)
      return assign(y, x) if y.is_a?(Variable)

      if x.is_a?(Sequence) and y.is_a?(Sequence)
        return nil unless x.size == y.size

        x.zip(y).inject(self) do |state, (a, b)|
          state && state.unify(a, b)
        end
      end
    end
  end

end
