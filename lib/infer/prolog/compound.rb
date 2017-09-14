module Infer
  module Prolog

    class Compound < Sequence
      def signature
        [functor.name, args.size]
      end

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
        if infix?
          x = left.with_parens rescue left.inspect
          y = right.with_parens rescue right.inspect
          "#{x} #{functor} #{y}"
        else
          "#{functor}(#{args.join(', ')})"
        end
      end

      def with_parens
        infix? ? super : inspect
      end

    private

      def infix?
        Builtin.print_infix?(self)
      end
    end

  end
end
