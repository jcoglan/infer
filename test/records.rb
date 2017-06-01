require_relative './_typeof'

LANG = Infer.lang('./tapl/11-7-records.txt')
EVAL = LANG.relation('->')

def many(expr)
  expr = Infer.expr(expr)

  loop do
    puts expr
    begin
      expr = EVAL.once(expr)
    rescue Infer::Stuck
      break
    end
  end
  puts
end

many 'if true then true else false'
many 'hello = true, ⊥'
many 'hello = (pred (succ 0)), ⊥'
many 'hello = (pred (succ 0)), (world = (iszero 0), ⊥)'
many '(hello = (pred (succ 0)), (world = (iszero 0), ⊥)).hello'

typeof LANG, 'hello = (pred (succ 0)), (world = (iszero 0), ⊥)'
typeof LANG, '(hello = (pred (succ 0)), (world = (iszero 0), ⊥)).world'
