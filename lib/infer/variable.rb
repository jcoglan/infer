module Infer

  Variable = Struct.new(:syntax_name, :index, :scope) do
    def name
      "#{syntax_name}#{index}"
    end

    def inspect
      name
    end
    alias :to_s :inspect

    def in_scope(scope)
      Variable.new(syntax_name, index, scope)
    end

    def map_vars
      yield self
    end
  end

end
