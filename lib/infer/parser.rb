module Infer

  class Parser
    def mk_language(t, a, b, el)
      blocks = el[1].elements.map(&:block)
      rules  = blocks.grep(Rule).map { |rule| [rule.name, rule] }

      Language.new(nil, Hash[rules])
    end

    def mk_syntax_block(t, a, b, el)
      rules = el[4].elements.map(&:syntax_smt)
      Syntax.new(Hash[rules])
    end

    def mk_syntax_clause(t, a, b, el)
      choices = [el[2]] + el[3].elements.map(&:el)
      [el[0].name, choices]
    end

    def mk_rule(t, a, b, el)
      name = el[2]

      pred = el[6].elements[0].elements[0]
      pred = pred ? [pred] : []

      cons = [el[6].elements[1]]

      Rule.new(name, pred, cons)
    end

    def mk_var(t, a, b, el)
      syntax_name = el[1].text
      index = el[2].text + el[3].text
      Variable.new(syntax_name, index)
    end

    def mk_refvar(t, a, b, el)
      el[0]
    end

    def mk_expr(t, a, b, el)
      return el[0] if el[1].elements.empty?
      parts = [el[0]] + el[1].elements.map(&:el)
      Sequence.new(parts)
    end

    def mk_sub_expr(t, a, b, el)
      el[2]
    end

    def mk_padded(t, a, b, el)
      el[1]
    end

    def mk_keyword(t, a, b, el)
      Word.new(t[a...b])
    end
  end

end
