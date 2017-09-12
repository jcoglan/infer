module Infer
  module Prolog

    class Compound < Sequence
      def functor
        items.first
      end

      def args
        items.drop(1)
      end

      def left
        args[0]
      end

      def right
        args[1]
      end

      def inspect
        "#{functor}(#{args.join(', ')})"
      end
      alias :with_parens :inspect
    end

  end
end
