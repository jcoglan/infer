module Infer

  Word = Struct.new(:name) do
    alias :inspect :name
    alias :to_s :inspect

    def in_scope(scope)
      self
    end

    def map_vars
      self
    end
  end

end
