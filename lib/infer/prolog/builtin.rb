module Infer
  module Prolog

    BUILTINS = {
      '='  => :eq,
      'is' => :is
    }

    METHODS = BUILTINS.merge(
      '+' => :plus,
      '-' => :minus
    )

    Builtin = Struct.new(:state) do
      def self.handle?(target)
        target.is_a?(Compound) and BUILTINS.has_key?(target.functor.name)
      end

      def evaluate(target)
        case target
        when Compound
          method = METHODS[target.functor.name]
          __send__(method, target)
        else
          state.walk(target)
        end
      end

      def eq(target)
        state.unify(target.left, target.right)
      end

      def is(target)
        state.unify(target.left, evaluate(target.right))
      end

      def math(target)
        x, y = evaluate(target.left), evaluate(target.right)
        Int.new(yield(x.value, y.value))
      end

      def plus(target)
        math(target) { |x, y| x + y }
      end

      def minus(target)
        math(target) { |x, y| x - y }
      end
    end

  end
end
