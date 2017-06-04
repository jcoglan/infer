require_relative './_evaluate'
require_relative './_typeof'

lang = Infer.lang('./tapl/11-13-lists.txt')

evaluate lang, 'nil[Nat]'
evaluate lang, 'cons[Nat] 0 (nil[Nat])'
evaluate lang, 'cons[Nat] (pred (succ 0)) (nil[Nat])'
evaluate lang, 'cons[Nat] (if (iszero 0) then (succ 0) else 0) (cons[Nat] (pred (succ 0)) (nil[Nat]))'
evaluate lang, 'head[Nat] (cons[Nat] (if (iszero 0) then (succ 0) else 0) (cons[Nat] (pred (succ 0)) (nil[Nat])))'
evaluate lang, 'tail[Nat] (cons[Nat] (if (iszero 0) then (succ 0) else 0) (cons[Nat] (pred (succ 0)) (nil[Nat])))'
evaluate lang, 'head[Nat] (tail[Nat] (cons[Nat] (if (iszero 0) then (succ 0) else 0) (cons[Nat] (pred (succ 0)) (nil[Nat]))))'

typeof lang, 'nil[Bool]'
typeof lang, 'cons[Bool] true (cons[Bool] false (nil[Bool]))'
typeof lang, 'cons[Bool] (if true then false else true) (cons[Bool] false (nil[Bool]))'
typeof lang, 'λx:Bool. (cons[Bool] (if x then x else false) (nil[Bool]))'
typeof lang, 'cons[(Bool → Bool)] (λx:Bool. x) (nil[(Bool → Bool)])'

lang = Infer.lang('./tapl/inferred-lists.txt')

typeof lang, 'cons 0 nil'
typeof lang, 'cons (succ 0) (cons 0 nil)'
typeof lang, 'λx:Nat. (λy:(List Nat). (cons x y))'
typeof lang, '(λx:Nat. (λy:(List Nat). (cons x y))) 0'
typeof lang, '((λx:Nat. (λy:(List Nat). (cons x y))) 0) nil'
typeof lang, 'cons (λx:Bool. (cons x nil)) nil'

typeof lang, 'cons (succ 0) (cons true nil)'
