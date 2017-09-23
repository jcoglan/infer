module Infer
  module Prolog

    class List < Sequence
      EMPTY   = Word.new('[]')
      FUNCTOR = Word.new('[|]')

      def self.nil
        List.new([])
      end

      def signature
        functor = empty? ? EMPTY : FUNCTOR
        [functor, items.size]
      end

      def empty?
        items.empty?
      end

      def head
        items.first
      end

      def tail
        items.last
      end

      def inspect
        "[#{contents}]"
      end
      alias :with_parens :inspect

      def contents
        return nil if head.nil?
        return head.inspect if tail.nil?

        case tail
        when List then [head.inspect, tail.contents].compact.join(', ')
        else "#{head} | #{tail}"
        end
      end
    end

  end
end
