require './lib/infer'

lang = Infer.parse_language(File.read './tapl/8-2.txt')
typeof = lang.relation(':')


expr = Infer.parse_expression <<-STR
  if (iszero (succ 0)) then 0 else (succ (succ 0))
STR

2.times { puts }
type, derivation = typeof.once_with_derivation(expr)
Infer.print_derivation(derivation)


expr = Infer.parse_expression <<-STR
  iszero (succ (if false then (if (iszero (succ 0)) then 0 else (succ 0)) else (pred 0)))
STR

2.times { puts }
type, derivation = typeof.once_with_derivation(expr)
Infer.print_derivation(derivation)


expr = Infer.parse_expression <<-STR
  if false then (pred 0) else (if (iszero (succ 0)) then 0 else (succ 0))
STR

2.times { puts }
type, derivation = typeof.once_with_derivation(expr)
Infer.print_derivation(derivation)


expr = Infer.parse_expression <<-STR
  if (iszero (succ 0)) then false else true
STR

puts
p expr
p [:type, typeof.once(expr)]


expr = Infer.parse_expression <<-STR
  if (iszero (succ 0)) then false else 0
STR

puts
p expr
p [:type, typeof.once(expr)]
