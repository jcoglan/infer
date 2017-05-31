require_relative './_typeof'

lang = Infer.lang('./tapl/typed-lambda-booleans-and-numbers.txt')

typeof lang, 'λx:Bool. (f (if x then false else x))', '∅ , f : (Bool → Bool)'
typeof lang, 'λx:Bool. (λy:Bool. (if x then y else false))'
