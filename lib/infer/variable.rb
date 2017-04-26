module Infer

  Variable = Struct.new(:syntax_name, :index) do
    def name
      syntax_name + index
    end

    def inspect
      '$' + name
    end
  end

end
