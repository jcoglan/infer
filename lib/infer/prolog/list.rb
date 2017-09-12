module Infer
  module Prolog

    class List < Sequence
      def self.nil
        List.new([])
      end

      def inspect
        "[#{contents}]"
      end
      alias :with_parens :inspect

      def contents
        head, tail = items

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
