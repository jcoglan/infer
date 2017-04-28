module Infer

  Word = Struct.new(:name) do
    alias :inspect :name

    def in_scope(scope)
      self
    end
  end

end
