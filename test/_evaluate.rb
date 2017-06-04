require_relative '../lib/infer'

def evaluate(lang, expr)
  expr = Infer.expr(expr)
  eval = lang.relation('->')

  loop do
    puts expr
    begin
      expr = eval.once(expr)
    rescue Infer::Stuck
      break
    end
  end
  puts
end
