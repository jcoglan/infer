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

typeof lang, 'λr: (x: Nat, Rcd). (r.x)'
typeof lang, '(λr: (x: Nat, Rcd). (r.x)) (x=0, ρ)'
typeof lang, '(λr: (x: Nat, (y: Bool, Rcd)). (r.x)) (x=0, (y=true, ρ))'
typeof lang, '(λr: (x: Nat, (y: Bool, Rcd)). (r.y)) (x=0, (y=true, ρ))'
