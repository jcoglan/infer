module Infer

  class Language
    def initialize
      @relations = {}
    end

    def augment(block)
      case block
      when Relation
        @relations[block.name] = block
      when Syntax
        @syntax = block
      end
    end

    def relation(name)
      rel = @relations.fetch(Word.new(name))
      rel.with_syntax(@syntax)
    end
  end

end
