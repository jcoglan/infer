module Infer

  Syntax = Struct.new(:rules) do
    ELLIPSIS = Word.new('...')
    MEMBER   = Word.new('←')

    def +(syntax)
      return self if syntax.nil?

      merged = syntax.rules.merge(rules) do |key, old_rule, new_rule|
        if new_rule.first == ELLIPSIS
          old_rule + new_rule.drop(1)
        else
          new_rule
        end
      end

      Syntax.new(merged)
    end

    def generate_rules(language)
      rules.each do |name, expressions|
        set_name = Word.new(name)
        expressions.each_with_index do |expression, i|
          rule_name = Word.new("_S-#{name}-#{i}")
          generate_expression_rule(language, set_name, rule_name, expression)
        end
      end
    end

    def augment_rule(rule)
      premises, conclusion = generate_premises(rule.conclusion)
      Rule.new(rule.name, rule.premises + premises, conclusion)
    end

  private

    def generate_expression_rule(language, set_name, rule_name, expression)
      return if expression == ELLIPSIS

      premises, expression = generate_premises(expression, true)

      conclusion = Sequence.new([expression, MEMBER, set_name])
      rule = Rule.new(rule_name, premises, conclusion, true)

      language.add_rule(rule, false)
    end

    def generate_premises(expression, renumber = false)
      vars = Set.new

      expression = expression.map_vars do |var|
        if renumber
          index = [nil, ''].include?(var.index) ? vars.size.to_s : var.index
          var = Variable.new(var.syntax_name, index)
        end
        var.tap { |v| vars.add(v) }
      end

      premises = vars.map do |var|
        if rules.has_key?(var.syntax_name)
          Sequence.new([var, MEMBER, Word.new(var.syntax_name)])
        end
      end

      [premises.compact, expression]
    end
  end

end
