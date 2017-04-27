module Infer

  Rule = Struct.new(:name, :premises, :conclusions) do
    def inspect
      "<rule [#{name.inspect}] #{premises.inspect} #{conclusions.inspect}>"
    end

    def match(target)
      conclusions.inject(State.new({})) do |state, expr|
        state && state.unify(target, expr)
      end
    end
  end

end
