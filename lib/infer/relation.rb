module Infer

  Ambiguous = Class.new(StandardError)
  Stuck = Class.new(StandardError)

  Relation = Struct.new(:language, :name) do
    def derive(term)
      result = Variable.new('<?>', '', Object.new)
      target = Sequence.new([term, Word.new(name), result])
      states = language.derive(target)

      case states.size
      when 0 then raise Stuck
      when 1 then [states.first, result]
      else raise Ambiguous
      end
    end

    def once_with_derivation(term)
      state, result = derive(term)
      [state.walk(result), state.build_derivation]
    end

    def once(term)
      state, result = derive(term)
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
