require './lib/infer'

lang = Infer.lang('./tapl/3-1-booleans.txt')

eval = lang.relation('->')

expr = Infer.expr('if true then true else false')
p [:p1, eval.once(expr)]

expr = Infer.expr('if false then true else false')
p [:p2, eval.once(expr)]

expr = Infer.expr('if (if true then false else true) then true else false')
p [:p3, eval.once(expr), eval.many(expr)]

expr = Infer.expr('if true then (if true then false else true) else false')
p [:p4, eval.once(expr), eval.many(expr)]

expr = Infer.expr <<-STR
  if (if (if true then true else true)
      then false
      else true)
  then true
  else false
STR
p [:p5, eval.once(expr), eval.many(expr)]
