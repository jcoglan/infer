module Infer

  Ambiguous = Class.new(StandardError)
  Stuck = Class.new(StandardError)

  Relation = Struct.new(:name, :rules, :syntax) do
    def with_syntax(syntax)
      Relation.new(name, rules, syntax)
    end

    def apply(term)
      result = Variable.new('<result>', '')
      target = Sequence.from(term) + Sequence.new([name, result])

      states = rules.map { |name, rule| rule.match(target) }.compact

      case states.size
      when 0 then raise Stuck
      when 1 then states.first.walk(result)
      else raise Ambiguous
      end
    end
  end

end
