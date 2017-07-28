module Infer

  Rule = Struct.new(:name, :premises, :conclusion, :syntactic) do
    def inspect
      "<rule #{name.inspect} #{premises.inspect} #{conclusion.inspect}>"
    end

    def match(lang, target, state)
      scope = Object.new
      expr  = conclusion.in_scope(scope)

      state = state.unify(target, expr)
      return [] unless state

      states = premises.inject([state.clear]) do |states, expr|
        states.flat_map do |state|
          lang.derive(expr.in_scope(scope), state).map { |s| s.connect(state) }
        end
      end

      states.map { |s| s.derive(name, expr, syntactic) }
    end
  end

end
