module Infer

  Sequence = Struct.new(:items) do
    def inspect
      items.map(&:inspect).join(' ')
    end
  end

end
