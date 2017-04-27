require './lib/infer'

defn = File.read('./tapl/3-1-booleans.txt')
lang = Infer.parse_language(defn)

p lang

eval = lang.relation('->')

expr = Infer.parse_expression('if true then true else false')
p [:p1, eval.once(expr)]

expr = Infer.parse_expression('if false then true else false')
p [:p2, eval.once(expr)]

expr = Infer.parse_expression('if (if true then false else true) then true else false')
p [:p3, eval.once(expr), eval.many(expr)]
