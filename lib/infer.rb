module Infer

  ROOT = File.expand_path('../infer', __FILE__)

  autoload :Language, ROOT + '/language'
  autoload :Relation, ROOT + '/relation'
  autoload :Rule,     ROOT + '/rule'
  autoload :Sequence, ROOT + '/sequence'
  autoload :State,    ROOT + '/state'
  autoload :Syntax,   ROOT + '/syntax'
  autoload :Variable, ROOT + '/variable'
  autoload :Word,     ROOT + '/word'

  autoload :Expression, ROOT + '/expression'
  autoload :Grammar,    ROOT + '/grammar'
  autoload :Parser ,    ROOT + '/parser'

  def self.parse_expression(text)
    Expression.parse(text, :actions => Parser.new)
  end

  def self.parse_language(text)
    Grammar.parse(text, :actions => Parser.new)
  end

  def self.print_derivation(derivation, d = 0)
    dent = '  ' * d
    puts "#{dent}- [#{derivation.rule}] #{derivation.conclusions.first}"
    derivation.parents.each do |deriv|
      print_derivation(deriv, d + 1)
    end
  end

end
