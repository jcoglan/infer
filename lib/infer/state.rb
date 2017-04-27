module Infer

  State = Struct.new(:values) do
    def assign(var, value)
      State.new(values.merge(var => value))
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
