module Infer
  module Prolog

    class Parser
      def initialize
        @counter = 0
      end

      def rule_name
        @counter += 1
        Word.new("_#{@counter}")
      end

      def mk_program(t, a, b, el)
        Language.new.tap do |lang|
          rules = el[1].elements.map(&:entry)
          rules.each { |rule| lang.add_rule(rule, false) }
        end
      end

      def mk_fact(t, a, b, el)
        Rule.new(rule_name, [], el[0])
      end

      def mk_rule(t, a, b, el)
        premises = [el[4]] + el[5].elements.map(&:goal)
        conclusion = el[0]
        Rule.new(rule_name, premises, conclusion)
      end

      def mk_infix(t, a, b, el)
        Compound.new([Word.new(el[2].text), el[0], el[4]])
      end

      def mk_cut(t, a, b)
        Cut.new(t[a...b])
      end

      def mk_list(t, a, b, el)
        List === el[2] ? el[2] : List.nil
      end

      def mk_list_contents(t, a, b, el)
        head = [el[0]] + el[1].elements.map(&:operand)
        tail = el[2].elements.any? ? el[2].operand : List.nil

        head.reverse.inject(tail) { |list, term| List.new([term, list]) }
      end

      def mk_compound(t, a, b, el)
        items = [el[0], el[3]] + el[4].elements.map(&:operand)
        Compound.new(items)
      end

      def mk_var(t, a, b, el)
        Variable.new(t[a...b])
      end

      def mk_integer(t, a, b, el)
        Int.new(t[a...b].to_i)
      end

      def mk_atom(t, a, b, el)
        Word.new(t[a...b])
      end
    end

  end
end
