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
end
