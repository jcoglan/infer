module Infer

  Rule = Struct.new(:name, :premises, :conclusions) do
    def inspect
      "<rule #{name.inspect} #{premises.inspect} #{conclusions.inspect}>"
    end

    def match(lang, target, state)
      scope = Object.new
      exprs = conclusions.map { |expr| expr.in_scope(scope) }

      state = conclusions.inject(state) do |state, expr|
        state && state.unify(target, expr.in_scope(scope))
      end

      return [] unless state

      states = premises.inject([state.clear]) do |states, expr|
        states.flat_map do |state|
          lang.derive(expr.in_scope(scope), state).map { |s| s.connect(state) }
        end
      end

      states.map { |s| s.derive(name, exprs) }
    end
  end

end
