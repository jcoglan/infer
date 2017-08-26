require_relative '../lib/infer'

def typeof(lang, expr, ctx = '∅')
  relation = lang.relation('⊢', ':')
  do_typeof(relation, ctx, expr)
end

def algo_typeof(lang, expr, ctx = '∅')
  relation = lang.relation('↦', ':')
  do_typeof(relation, ctx, expr)
end

def ref_typeof(lang, expr, ctx = '∅', env = '∅')
  relation = lang.relation('|', '⊢', ':')
  do_typeof(relation, ctx, env, expr)
end

def do_typeof(relation, *args)
  expr = args.last
  args = args.map { |expr| Infer.expr(expr) }
  type, derivation = relation.once_with_derivation(*args)
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
