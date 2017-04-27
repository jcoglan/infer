module Infer

  Sequence = Struct.new(:items) do
    include Enumerable

    def inspect
      '(' + items.map(&:inspect).join(' ') + ')'
    end

    def rule=(rule)
      each { |expr| expr.rule = rule }
    end

    def each
      items.each { |v| yield v }
    end

    def size
      items.size
    end
  end

end
