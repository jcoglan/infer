module Infer

  Rule = Struct.new(:name, :premises, :conclusions) do
    def inspect
      "<rule [#{name.inspect}] #{premises.inspect} #{conclusions.inspect}>"
    end
  end

end
