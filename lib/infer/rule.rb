module Infer

  Rule = Struct.new(:name, :premises, :conclusion, :syntactic) do
    def inspect
      body = premises.map(&:inspect).join(', ')
      "<rule #{name.inspect} #{conclusion.inspect} :- #{body}>"
    end

    def match(lang, target, state)
      scope = Object.new
      expr  = conclusion.in_scope(scope)

      state = state.unify(target, expr)
      return [].each unless state

      states = premises.inject([state.clear].each) do |states, expr|
        match_in_states(lang, expr.in_scope(scope), states)
      end

      states.lazy.map { |s| s.derive(name, expr, syntactic) }
    end

    def match_in_states(lang, expr, states)
      Enumerator.new { |enum|
        state = states.next
        next enum.yield(state.cut!) if expr.is_a?(Cut)

        head = match_in_state(lang, expr, state)
        tail = match_in_states(lang, expr, states)

        lang.interleave([head, tail]).each do |state|
          enum.yield(state)
        end
      }
    end

    def match_in_state(lang, expr, state)
      return [state].each if state.failed?

      Enumerator.new { |enum|
        empty = true

        lang.derive(expr, state).each do |new_state|
          empty = false
          enum.yield(new_state.connect(state))
        end

        enum.yield(state.failed!) if empty and state.cut == 1
      }
    end
  end

end
