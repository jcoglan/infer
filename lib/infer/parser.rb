module Infer

  Parser = Struct.new(:pathname) do
    def mk_language(t, a, b, el)
      blocks = el[1].elements.map(&:block)

      langs  = blocks.grep(Language)
      syntax = blocks.grep(Syntax)
      rules  = blocks.grep(Rule)
      proofs = blocks.grep(Proof)

      Language.new.tap do |lang|
        langs.each  { |l| lang.import(l) }
        syntax.each { |s| lang.add_syntax(s) }
        rules.each  { |r| lang.add_rule(r) }
        proofs.each { |p| lang.add_proof(p) }
      end
    end

    def mk_extends(t, a, b, el)
      path = File.expand_path(el[2].text, File.dirname(pathname))
      Infer.lang(path, :syntax => false)
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
      expr = el[7].elements

      if expr[0].elements.empty?
        pred = []
      else
        pred = [expr[0].rule_expr] + expr[0].elements[1].map(&:rule_expr)
      end
      pred << el[4].cut if el[4].respond_to?(:cut)

      Rule.new(name, pred, expr[1])
    end

    def mk_proof(t, a, b, el)
      Proof.new(t[a...b], el[4])
    end

    def mk_loop(t, a, b, el)
      Proof.new(t[a...b], el[6], el[2])
    end

    def mk_var(t, a, b, el)
      syntax_name = el[1].text
      index = el[2].text + el[3].text
      Variable.new(syntax_name, index)
    end

    def mk_refvar(t, a, b, el)
      el[0]
    end

    def mk_cut(t, a, b)
      Cut.new(t[a...b])
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
