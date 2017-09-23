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
      def self.handle?(term)
        term.is_a?(Compound) and FUNCTORS.include?(term.signature)
      end

      def self.print_infix?(term)
        INFIX.include?(term.signature)
      end

      def evaluate(term)
        return term unless term.is_a?(Compound)

        signature = term.signature

        if SPECIAL.has_key?(signature)
          __send__(SPECIAL[signature], term)

        elsif COMPARATORS.has_key?(signature)
          compare(term)

        elsif MATH.has_key?(signature)
          Int.new(math(term, MATH))

        elsif TYPE.has_key?(signature)
          __send__(TYPE[signature], term.left) ? state : nil
        end
      end

      def equal(term)
        state.unify(term.left, term.right)
      end

      def is(term)
        state.unify(term.left, evaluate(term.right))
      end

      def identical(term)
        term.left == term.right ? state : nil
      end

      def not_identical(term)
        identical(term) ? nil : state
      end

      def functor(term)
        compound, functor, arity = term.args

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

      def compare(term)
        result = math(term, COMPARATORS)
        result ? state : nil
      end

      def math(term, table)
        x = evaluate(term.left).value
        y = evaluate(term.right).value

        x.__send__(table[term.signature], y)
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
