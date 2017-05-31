module Infer

  Ambiguous = Class.new(StandardError)
  Stuck = Class.new(StandardError)

  Relation = Struct.new(:language, :symbols) do
    def derive(*terms)
      result = Variable.new('<?>')
      ops    = symbols.map { |sym| Word.new(sym) }
      target = Sequence.new(terms.zip(ops).inject([], &:+) + [result])
      states = language.derive(target)

      case states.size
      when 0 then raise Stuck
      when 1 then [states.first, result]
      else raise Ambiguous
      end
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
