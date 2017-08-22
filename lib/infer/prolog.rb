module Infer
  module Prolog

    autoload :Program, ROOT + '/prolog/program'

    def self.program(program)
      Program.parse(program, :actions => Parser.new)
    end

    def self.query(query)
      query = program(query)
      query = query.rules.values.first.conclusion

      vars = []
      query.map_vars { |var| vars << var }

      [query, vars]
    end

    def self.print_results(states, vars)
      first = states.next rescue nil
      return puts "false.\n\n" unless first

      puts
      print_state(first, vars)

      states.each do |state|
        print_state(state, vars)
      end
    end

    def self.print_state(state, vars)
      Infer.print_derivation(state.build_derivation)
      puts

      return puts "true.\n\n" if vars.empty?

      vars.each do |var|
        puts "#{var} = #{state.walk(var)}"
      end

      puts
    end

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

    class Compound < Sequence
      def inspect
        functor, args = items.first, items.drop(1)
        "#{functor}(#{args.join(', ')})"
      end
      alias :with_parens :inspect
    end

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
        premises = [el[4]] + el[5].elements.map(&:term)
        conclusion = el[0]
        Rule.new(rule_name, premises, conclusion)
      end

      def mk_list(t, a, b, el)
        List === el[2] ? el[2] : List.nil
      end

      def mk_list_contents(t, a, b, el)
        head = [el[0]] + el[1].elements.map(&:term)
        tail = el[2].elements.any? ? el[2].term : List.nil

        head.reverse.inject(tail) { |list, term| List.new([term, list]) }
      end

      def mk_compound(t, a, b, el)
        items = [el[0], el[3]] + el[4].elements.map(&:term)
        Compound.new(items)
      end

      def mk_var(t, a, b, el)
        Variable.new(t[a...b])
      end

      def mk_atom(t, a, b, el)
        Word.new(t[a...b])
      end
    end

  end
end
