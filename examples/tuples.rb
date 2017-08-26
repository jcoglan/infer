require_relative './_evaluate'
require_relative './_typeof'

lang = Infer.lang('./tapl/11-6-tuples')

evaluate lang, 'τ'
evaluate lang, '0, τ'
evaluate lang, '(iszero (pred (succ 0))), ((if false then 0 else (succ 0)), τ)'
evaluate lang, '((iszero (pred (succ 0))), ((if false then 0 else (succ 0)), τ)) . (+0)'

typeof lang, '0, (true, τ)'
typeof lang, '(0, (true, τ)) . 0'
typeof lang, '(0, (true, τ)) . (+0)'
typeof lang, '0, ((if true then (succ 0) else 0), τ)'
typeof lang, '(iszero 0), (0, ((if true then (succ 0) else 0), τ))'
typeof lang, '(0, (false, ((pred 0), τ))) . (+0)'
typeof lang, '(0, (false, ((pred 0), τ))) . (+(+0))'

typeof lang, 'succ ((0, (false, ((pred 0), τ))) . (+(+0)))'
