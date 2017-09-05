require_relative './_typeof'

lang = Infer.lang('./tapl/11-4-let-binding')

typeof lang, 'λx:Bool. (f (if x then false else x))', '∅ , f : (Bool → Bool)'
typeof lang, 'λx:Bool. (λy:Bool. (if x then y else false))'
typeof lang, 'λx:Bool. (λy:Bool. (λx:Nat. x))'
