module Infer

  Ambiguous = Class.new(StandardError)
  Stuck = Class.new(StandardError)

  Relation = Struct.new(:name, :rules, :syntax) do
    def with_syntax(syntax)
      Relation.new(name, rules, syntax)
    end

    def derive(target, state = State.new({}))
      rules.flat_map { |name, rule| rule.match(self, target, state) }
    end

    def once(term)
      result = Variable.new('<?>', '')
      target = Sequence.new([term, name, result])
      states = derive(target)

      case states.size
      when 0 then raise Stuck
      when 1 then states.first.walk(result)
      else raise Ambiguous
      end
    end

    def many(term)
      loop do
        begin
          term = once(term)
        rescue Stuck
          return term
        end
      end
    end
  end

end
