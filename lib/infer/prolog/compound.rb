module Infer
  module Prolog

    class Compound < Sequence
      def inspect
        functor, args = items.first, items.drop(1)
        "#{functor}(#{args.join(', ')})"
      end
      alias :with_parens :inspect
    end

  end
end
