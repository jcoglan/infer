module Infer
  module Prolog

    EQ = Word.new('=')

    DefiniteClause = Struct.new(:name, :premises, :conclusion) do
      def self.vars(used)
        Enumerator.new { |enum|
          var = Variable.new('A')
          loop {
            var = Variable.new(var.name.succ) while used.member?(var)
            enum.yield(var)
            var = Variable.new(var.name.succ)
          }
        }
      end

      def rewrite
        index = 0 ... premises.size
        chain = index.zip(premises).reject { |i, t| t.is_a?(Array) }

        used  = Prolog.extract_vars(premises.flatten)
        vars  = DefiniteClause.vars(used).take(chain.size + 1)

        head  = transform(conclusion, vars.first, vars.last)

        chain = chain.zip(vars.each_cons(2)).map do |(i, premise), (x, y)|
          [i, transform(premise, x, y)]
        end

        chain = optimise(chain)
        combine(head, chain, -2)

        chain = chain.to_h
        body  = index.flat_map { |i| chain.fetch(i, premises[i]) }

        Rule.new(name, body, head)
      end

      def transform(term, x, y)
        case term
        when List     then Compound.new([EQ, x, append_list(term, y)])
        when Compound then Compound.new(term.items + [x, y])
        when Word     then Compound.new([term, x, y])
        end
      end

      def append_list(list, var)
        if list.empty?
          var
        else
          List.new([list.head, append_list(list.tail, var)])
        end
      end

      def optimise(chain)
        result = []

        until chain.empty?
          i, term = chain.shift
          combine(term, chain, -1)
          result << [i, term]
        end

        result
      end

      def combine(term, chain, index)
        _, head = chain.first
        return unless [term, head].all? { |t| t.is_a?(Compound) }

        if head and head.functor == EQ and term.items[index] == head.left
          term.items[index] = head.right
          chain.first[1]    = []
        end
      end
    end

  end
end
