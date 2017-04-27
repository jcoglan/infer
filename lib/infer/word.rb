module Infer

  Word = Struct.new(:name) do
    alias :inspect :name

    def rule=(rule)
    end
  end

end
