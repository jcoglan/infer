module Infer

  Rule = Struct.new(:name, :premises, :conclusion, :syntactic) do
    def inspect
      "<rule #{name.inspect} #{premises.inspect} #{conclusion.inspect}>"
    end

    def match(lang, target, state)
      scope = Object.new
      expr  = conclusion.in_scope(scope)

      states = Enumerator.new { |enum|
        state = state.unify(target, expr)
        enum.yield(state.clear) if state
      }

      states = premises.inject(states) do |states, expr|
        match_in_states(lang, expr.in_scope(scope), states)
      end

      states.lazy.map { |s| s.derive(name, expr, syntactic) }
    end

    def match_in_states(lang, expr, states)
      Enumerator.new { |enum|
        state = states.next
        head  = lang.derive(expr, state).lazy.map { |s| s.connect(state) }
        tail  = match_in_states(lang, expr, states)

        lang.interleave([head, tail]).each do |state|
          enum.yield(state)
        end
      }
    end
  end

end
