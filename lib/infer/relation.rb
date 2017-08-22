module Infer

  Ambiguous = Class.new(StandardError)
  Stuck = Class.new(StandardError)

  Relation = Struct.new(:language, :symbols) do
    def derive(*terms)
      result = Variable.new('<?>')
      ops    = symbols.map { |sym| Word.new(sym) }
      target = Sequence.new(terms.zip(ops).inject([], &:+) + [result])
      states = language.derive(target)

      first = states.next rescue nil
      raise Stuck unless first

      tail = states.next rescue nil
      raise Ambiguous if tail

      [first, result]
    end

    def once_with_derivation(*terms)
      state, result = derive(*terms)
      [state.walk(result), state.build_derivation]
    end

    def once(*terms)
      state, result = derive(*terms)
      state.walk(result)
    end

    def many(term)
      loop do
        begin
          term = once(term)
        rescue Stuck
          return term
        end
      end
    end
  end

end
