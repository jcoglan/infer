module Infer

  Ambiguous = Class.new(StandardError)
  Stuck = Class.new(StandardError)

  Relation = Struct.new(:language, :name) do
    def once(term)
      result = Variable.new('<?>', '')
      target = Sequence.new([term, Word.new(name), result])
      states = language.derive(target)

      case states.size
      when 0 then raise Stuck
      when 1 then states.first.walk(result)
      else raise Ambiguous
      end
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
