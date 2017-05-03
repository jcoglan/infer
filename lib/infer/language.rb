module Infer

  class Language
    attr_reader :rules, :syntax

    def initialize
      @rules  = {}
      @syntax = nil
    end

    def import(language)
      add_syntax(language.syntax)
      @rules = language.rules.merge(@rules)
    end

    def add_syntax(syntax)
      @syntax = syntax + @syntax
      @syntax.generate_rules(self)
    end

    def add_rule(rule, apply_syntax = true)
      rule = @syntax.augment_rule(rule) if apply_syntax
      @rules[rule.name] = rule
    end

    def relation(name)
      Relation.new(self, name)
    end

    def derive(target, state = State.new({}))
      rules.flat_map { |_, rule| rule.match(self, target, state) }
    end
  end

end
