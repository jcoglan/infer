module Infer

  Word = Struct.new(:name) do
    alias :inspect :name
  end

end
