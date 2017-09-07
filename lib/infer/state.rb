module Infer

  Derivation = Struct.new(:parents, :rule, :conclusion, :syntactic) do
    alias :syntactic? :syntactic

    def in_state(state)
      parents  = self.parents.map { |d| d.in_state(state) }
      conclude = state.walk(self.conclusion)
      Derivation.new(parents, rule, conclude, syntactic)
    end
  end

  State = Struct.new(:values, :cut, :derivation) do
    def assign(var, value)
      State.new(values.merge(var => value), cut, derivation)
    end

    def cut!
      State.new(values, 1, derivation)
    end

    def cut?
      cut == 2
    end

    def failed!
      failed? ? self : State.new(nil, cut)
    end

    def failed?
      values.nil?
    end

    def clear
      State.new(values)
    end

    def connect(state)
      cut = [state.cut, self.cut].grep(1).first
      State.new(values, cut, state.parents + [derivation])
    end

    def derive(rule, conclusion, syntactic)
      cut = {1 => 2}.fetch(self.cut, 0)
      State.new(values, cut, Derivation.new(parents, rule, conclusion, syntactic))
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
        value.class.new(value.map { |v| walk(v) })
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
        return nil unless x.class == y.class and x.size == y.size

        x.zip(y).inject(self) do |state, (a, b)|
          state && state.unify(a, b)
        end
      end
    end
  end

end
