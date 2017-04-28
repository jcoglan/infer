module Infer

  Sequence = Struct.new(:items) do
    include Enumerable

    def inspect
      '(' + map(&:inspect).join(' ') + ')'
    end

    def each
      items.each { |v| yield v }
    end

    def size
      items.size
    end

    def in_scope(scope)
      Sequence.new(map { |v| v.in_scope(scope) })
    end
  end

end
