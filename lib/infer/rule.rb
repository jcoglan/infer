module Infer

  Rule = Struct.new(:name, :premises, :conclusions) do
    def inspect
      "<rule [#{name.inspect}] #{premises.inspect} #{conclusions.inspect}>"
    end

    def match(relation, target, state)
      state = conclusions.inject(state) do |state, expr|
        state && state.unify(target, expr)
      end

      return [] unless state

      premises.inject([state]) do |states, expr|
        states.flat_map { |state| relation.derive(expr, state) }
      end
    end
  end

end
