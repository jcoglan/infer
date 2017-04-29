module Infer

  Word = Struct.new(:name) do
    alias :inspect :name
    alias :to_s :inspect

    def in_scope(scope)
      self
    end
  end

end
