require_relative './_typeof'

lang = Infer.lang('./tapl/11-4-let-binding')

typeof lang, 'let x = 0 in (iszero (succ x))'
