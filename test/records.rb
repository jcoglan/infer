require_relative './_evaluate'
require_relative './_typeof'

lang = Infer.lang('./tapl/11-7-records')

evaluate lang, 'if true then true else false'
evaluate lang, 'hello = true, ρ'
evaluate lang, 'hello = (pred (succ 0)), ρ'
evaluate lang, 'hello = (pred (succ 0)), (world = (iszero 0), ρ)'
evaluate lang, '(hello = (pred (succ 0)), (world = (iszero 0), ρ)).hello'

typeof lang, 'hello = (pred (succ 0)), (world = (iszero 0), ρ)'
typeof lang, '(hello = (pred (succ 0)), (world = (iszero 0), ρ)).world'
