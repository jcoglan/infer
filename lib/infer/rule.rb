module Infer

  Rule = Struct.new(:name, :premises, :conclusions) do
    def inspect
      "<rule #{name.inspect} #{premises.inspect} #{conclusions.inspect}>"
    end

    def match(lang, target, state)
      scope = Object.new

      state = conclusions.inject(state) do |state, expr|
        state && state.unify(target, expr.in_scope(scope))
      end

      return [] unless state

      premises.inject([state]) do |states, expr|
        states.flat_map { |state| lang.derive(expr.in_scope(scope), state) }
      end
    end
  end

end
