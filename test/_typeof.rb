require_relative '../lib/infer'

def typeof(lang, expr, ctx = '∅')
  relation = lang.relation('⊢', ':')
  type, derivation = relation.once_with_derivation(Infer.expr(ctx), Infer.expr(expr))

  expr = expr.gsub(/\n */, ' ').strip

  puts
  puts "# #{expr}"
  puts "# #{'-' * expr.to_s.size}"
  puts "# #{type}"
  puts
  Infer.print_derivation(derivation)
  puts
end
