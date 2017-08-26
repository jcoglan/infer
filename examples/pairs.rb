require_relative './_typeof'

lang = Infer.lang('./tapl/11-5-pairs')

typeof lang, 'λx : Bool. x'
typeof lang, 'λx : Bool. (x,x)'
typeof lang, '(λx : Bool. (x,x)) true'
typeof lang, '((λx : Bool. (x,x)) true).2'
typeof lang, '(((λx : Bool. (λy : Bool. (x,y))) true) false).2'
