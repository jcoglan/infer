module Infer

  Variable = Struct.new(:syntax_name, :index, :rule) do
    def name
      syntax_name + index
    end

    def inspect
      '$' + name
    end
  end

end
