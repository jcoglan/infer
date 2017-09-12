module Infer
  module Prolog

    BUILTINS = {
      '='  => :eq,
      'is' => :is
    }

    COMPARATORS = {
      '=:=' => :==,
      '=\=' => :!=,
      '=<'  => :<=,
      '<'   => :<,
      '>='  => :>=,
      '>'   => :>
    }

    FUNCTORS = BUILTINS.keys + COMPARATORS.keys

    MATH = {
      '+' => :+,
      '-' => :-
    }

    Builtin = Struct.new(:state) do
      def self.handle?(target)
        target.is_a?(Compound) and FUNCTORS.include?(target.functor.name)
      end

      def evaluate(target)
        return state.walk(target) unless target.is_a?(Compound)

        name = target.functor.name

        if BUILTINS.has_key?(name)
          __send__(BUILTINS[name], target)
        elsif COMPARATORS.has_key?(name)
          compare(target)
        elsif MATH.has_key?(name)
          Int.new(math(target, MATH))
        end
      end

      def eq(target)
        state.unify(target.left, target.right)
      end

      def is(target)
        state.unify(target.left, evaluate(target.right))
      end

      def compare(target)
        result = math(target, COMPARATORS)
        result ? state : nil
      end

      def math(target, table)
        x = evaluate(target.left).value
        y = evaluate(target.right).value

        x.__send__(table[target.functor.name], y)
      end
    end

  end
end
