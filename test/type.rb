require './lib/infer'

lang = Infer.parse_language(File.read './tapl/8-2.txt')
typeof = lang.relation(':')


expr = Infer.parse_expression <<-STR
  if (iszero (succ 0)) then 0 else (succ 0)
STR

puts
p expr
p [:type, typeof.once(expr)]


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
