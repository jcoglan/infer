module Infer
  class Parser

    def self.parse(text)
      Grammar.parse(text, :actions => Actions.new)
    end

    class Actions
      def mk_language(t, a, b, el)
        lang = Language.new
        el[1].elements.each { |elem| lang.augment(elem.block) }
        lang
      end

      def mk_syntax_block(t, a, b, el)
        rules = el[4].elements.map(&:syntax_smt)
        Syntax.new(Hash[rules])
      end

      def mk_syntax_rule(t, a, b, el)
        choices = [el[2]] + el[3].elements.map(&:el)
        [el[0].name, choices]
      end

      def mk_relation_block(t, a, b, el)
        name  = el[2]
        rules = el[6].elements.map(&:rule_smt)
        Relation.new(name, Hash[rules])
      end

      def mk_relation_rule(t, a, b, el)
        name = el[0]
        pred = el[4].elements[0].elements[0]
        cons = el[4].elements[1]

        rule = Rule.new(name, pred ? [pred] : [], [cons])
        [name, rule]
      end

      def mk_expr(t, a, b, el)
        return el[0] if el[1].elements.empty?
        parts = [el[0]] + el[1].elements.map(&:el)
        Sequence.new(parts)
      end

      def mk_keyword(t, a, b, el)
        Word.new(t[a...b])
      end

      def mk_var(t, a, b, el)
        Variable.new(el[1].text, el[2].text + el[3].text)
      end

      def mk_refvar(t, a, b, el)
        el[0]
      end
    end

  end
end
