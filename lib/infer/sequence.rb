module Infer

  Sequence = Struct.new(:items) do
    include Enumerable

    def self.from(value)
      return value if value.is_a?(Sequence)
      Sequence.new([value])
    end

    def inspect
      items.map(&:inspect).join(' ')
    end

    def each
      items.each { |v| yield v }
    end

    def size
      items.size
    end

    def +(other)
      Sequence.new(items + other.items)
    end
  end

end
