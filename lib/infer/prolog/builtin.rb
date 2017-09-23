module Infer
  module Prolog

    BUILTINS = {
      ['=', 2]   => :equal,
      ['is', 2]  => :is,
      ['==', 2]  => :identical,
      ['\==', 2] => :not_identical
    }

    COMPARATORS = {
      ['=:=', 2] => :==,
      ['=\=', 2] => :!=,
      ['=<', 2]  => :<=,
      ['<', 2]   => :<,
      ['>=', 2]  => :>=,
      ['>', 2]   => :>
    }

    MATH = {
      ['+', 2]   => :+,
      ['-', 2]   => :-,
      ['*', 2]   => :*,
      ['/', 2]   => :/,
      ['mod', 2] => '%'
    }

    FUNCTORS = BUILTINS.keys + COMPARATORS.keys
    INFIX    = FUNCTORS + MATH.keys

    Builtin = Struct.new(:state) do
      def self.handle?(target)
        target.is_a?(Compound) and FUNCTORS.include?(target.signature)
      end

      def self.print_infix?(target)
        INFIX.include?(target.signature)
      end

      def evaluate(target)
        return state.walk(target) unless target.is_a?(Compound)

        signature = target.signature

        if BUILTINS.has_key?(signature)
          __send__(BUILTINS[signature], target)
        elsif COMPARATORS.has_key?(signature)
          compare(target)
        elsif MATH.has_key?(signature)
          Int.new(math(target, MATH))
        end
      end

      def equal(target)
        state.unify(target.left, target.right)
      end

      def is(target)
        state.unify(target.left, evaluate(target.right))
      end

      def identical(target)
        left, right = state.walk(target.left), state.walk(target.right)
        left == right ? state : nil
      end

      def not_identical(target)
        identical(target) ? nil : state
      end

      def compare(target)
        result = math(target, COMPARATORS)
        result ? state : nil
      end

      def math(target, table)
        x = evaluate(target.left).value
        y = evaluate(target.right).value

        x.__send__(table[target.signature], y)
      end
    end

  end
end
