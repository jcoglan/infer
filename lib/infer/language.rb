module Infer

  Language = Struct.new(:syntax, :rules) do
    def relation(name)
      Relation.new(self, name)
    end

    def derive(target, state = State.new({}))
      rules.flat_map { |rule| rule.match(self, target, state) }
    end
  end

end
