require 'set'

module Infer
  ROOT = File.expand_path('../infer', __FILE__)

  autoload :Language, ROOT + '/language'
  autoload :Relation, ROOT + '/relation'
  autoload :Rule,     ROOT + '/rule'
  autoload :State,    ROOT + '/state'
  autoload :Syntax,   ROOT + '/syntax'
  autoload :Proof,    ROOT + '/proof'

  autoload :Sequence, ROOT + '/sequence'
  autoload :Variable, ROOT + '/variable'
  autoload :Word,     ROOT + '/word'

  autoload :Printer, ROOT + '/printer'

  autoload :Grammar, ROOT + '/grammar'
  autoload :Parser,  ROOT + '/parser'

  autoload :Prolog, ROOT + '/prolog'

  EXTENSIONS = ['', '.infer', '.md', '.txt']

  def self.lang(pathname, options = {})
    pathname += EXTENSIONS.find { |ext| File.file?(pathname + ext) }
    parser    = Parser.new(pathname)
    language  = Grammar.parse(File.read(pathname), :actions => parser)

    unless options[:syntax] == false
      language.syntax.generate_rules(language)
    end

    language
  end

  def self.print_derivation(derivation, options = {})
    Printer.new(derivation, options).print
  end
end
