require './lib/infer'

lang = Infer.lang('./tapl/8-2-typing-rules-for-numbers.txt')
typeof = lang.relation(':')

lang.rules.each { |_, rule| p rule }


expr = Infer.expr <<-STR
  if (iszero (succ 0)) then 0 else (succ (succ 0))
STR

2.times { puts }
type, derivation = typeof.once_with_derivation(expr)
Infer.print_derivation(derivation)


expr = Infer.expr <<-STR
  iszero (succ (if false then (if (iszero (succ 0)) then 0 else (succ 0)) else (pred 0)))
STR

2.times { puts }
type, derivation = typeof.once_with_derivation(expr)
Infer.print_derivation(derivation)


expr = Infer.expr <<-STR
  if false then (pred 0) else (if (iszero (succ 0)) then 0 else (succ 0))
STR

2.times { puts }
type, derivation = typeof.once_with_derivation(expr)
Infer.print_derivation(derivation)


expr = Infer.expr <<-STR
  if (iszero (succ 0)) then false else true
STR

puts
p expr
p [:type, typeof.once(expr)]


expr = Infer.expr <<-STR
  if (iszero (succ 0)) then false else 0
STR

puts
p expr
p [:type, typeof.once(expr)]
