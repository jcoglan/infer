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

    REFLECT = {
      ['functor', 3] => :functor
    }

    TYPE = {
      ['atom', 1]    => :atom?,
      ['integer', 1] => :integer?,
      ['number', 1]  => :number?,
      ['atomic', 1]  => :atomic?,
      ['var', 1]     => :var?,
      ['nonvar', 1]  => :nonvar?
    }

    SPECIAL  = BUILTINS.merge(REFLECT)
    FUNCTORS = [BUILTINS, COMPARATORS, REFLECT, TYPE].flat_map(&:keys)
    INFIX    = [BUILTINS, COMPARATORS, MATH].flat_map(&:keys)

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

        if SPECIAL.has_key?(signature)
          __send__(SPECIAL[signature], target)

        elsif COMPARATORS.has_key?(signature)
          compare(target)

        elsif MATH.has_key?(signature)
          Int.new(math(target, MATH))

        elsif TYPE.has_key?(signature)
          arg = state.walk(target).left
          __send__(TYPE[signature], arg) ? state : nil
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

      def functor(target)
        compound, functor, arity = state.walk(target).args

        if compound.is_a?(Variable)
          scope = Object.new
          vars  = Variable.generator.take(arity.value)
          items = [functor] + vars.map { |v| v.in_scope(scope) }
          return state.unify(compound, Compound.new(items))
        end

        sig = compound.respond_to?(:signature) ?
              compound.signature :
              [compound, 0]

        state.unify(functor, sig[0]).unify(arity, Int.new(sig[1]))
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

      def atom?(term)
        term.is_a?(Word)
      end

      def integer?(term)
        term.is_a?(Int)
      end

      def number?(term)
        integer?(term)
      end

      def atomic?(term)
        atom?(term) or var?(term)
      end

      def var?(term)
        term.is_a?(Variable)
      end

      def nonvar?(term)
        not var?(term)
      end
    end

  end
end
