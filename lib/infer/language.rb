module Infer

  class Language
    attr_reader :rules, :syntax

    def initialize
      @rules  = {}
      @syntax = Syntax.new({})
    end

    def import(language)
      add_syntax(language.syntax)
      @rules = language.rules.merge(@rules)
    end

    def add_syntax(syntax)
      @syntax = syntax + @syntax
    end

    def add_rule(rule, apply_syntax = true)
      rule = @syntax.augment_rule(rule) if apply_syntax and !ENV['NOSYNTAX']
      @rules[rule.name] = rule
    end

    def relation(*symbols)
      Relation.new(self, symbols)
    end

    def derive(target, state = State.new({}))
      rules.flat_map { |_, rule| rule.match(self, target, state) }
    end
  end

end
