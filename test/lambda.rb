require './lib/infer'

lang = Infer.lang('./tapl/pure-simply-typed-lambda-calculus-with-booleans.txt')


expr = Infer.expr <<-STR
  (∅ , f : (Bool → Bool)) ⊢ (λx:Bool. (f (if x then false else x))) : (Bool → Bool)
STR

states = lang.derive(expr)
Infer::Printer.new(states.first.build_derivation).print_simple
puts


expr = Infer.expr <<-STR
  ∅ ⊢ (λx:Bool. (λy:Bool. (if x then y else false))) :
STR

expr = Infer::Sequence.new(expr.items + [Infer::Variable.new('?')])

states = lang.derive(expr)
Infer.print_derivation(states.first.build_derivation)
puts
