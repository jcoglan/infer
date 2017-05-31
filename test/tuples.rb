require_relative './_typeof'

lang = Infer.lang('./tapl/11-6-tuples.txt')

typeof lang, '0, (true, ⊥)'
typeof lang, '(0, (true, ⊥)) . 0'
typeof lang, '(0, (true, ⊥)) . (+0)'
typeof lang, '0, ((if true then (succ 0) else 0), ⊥)'
typeof lang, '(iszero 0), (0, ((if true then (succ 0) else 0), ⊥))'
typeof lang, '(0, (false, ((pred 0), ⊥))) . (+(+0))'

typeof lang, 'succ ((0, (false, ((pred 0), ⊥))) . (+(+0)))'
