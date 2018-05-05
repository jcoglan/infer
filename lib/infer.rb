require 'pathname'
require 'set'

module Infer
  ROOT = Pathname.new(File.expand_path('..', __FILE__)).join('infer')

  autoload :Language, ROOT.join('language')
  autoload :Relation, ROOT.join('relation')
  autoload :Rule,     ROOT.join('rule')
  autoload :State,    ROOT.join('state')
  autoload :Syntax,   ROOT.join('syntax')
  autoload :Proof,    ROOT.join('proof')

  autoload :Sequence, ROOT.join('sequence')
  autoload :Variable, ROOT.join('variable')
  autoload :Word,     ROOT.join('word')

  autoload :Pager  , ROOT.join('pager')
  autoload :Printer, ROOT.join('printer')

  autoload :Grammar, ROOT.join('grammar')
  autoload :Parser,  ROOT.join('parser')

  autoload :Prolog, ROOT.join('prolog')

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
