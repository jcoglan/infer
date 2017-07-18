require_relative '../lib/infer'

def typeof(lang, expr, ctx = '∅')
  relation = lang.relation('⊢', ':')

  type, derivation = relation.once_with_derivation(Infer.expr(ctx), Infer.expr(expr))

  print_derivation(expr, type, derivation)
end

def ref_typeof(lang, expr, ctx = '∅', env = '∅')
  relation = lang.relation('|', '⊢', ':')

  type, derivation = relation.once_with_derivation(
    Infer.expr(ctx), Infer.expr(env), Infer.expr(expr))

  print_derivation(expr, type, derivation)
end

def print_derivation(expr, type, derivation)
  expr = expr.gsub(/\n */, ' ').strip

  puts
  puts "# #{expr}"
  puts "# #{'-' * expr.to_s.size}"
  puts "# #{type}"
  puts
  Infer.print_derivation(derivation)
  puts
end
