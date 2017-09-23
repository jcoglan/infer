module Infer

  Variable = Struct.new(:syntax_name, :index, :scope) do
    def self.generator(used = Set.new)
      Enumerator.new { |enum|
        var = new('A')
        loop {
          var = new(var.name.succ) while used.member?(var)
          enum.yield(var)
          var = new(var.name.succ)
        }
      }
    end

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
