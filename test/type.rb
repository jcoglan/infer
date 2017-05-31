require './lib/infer'

LANG = Infer.lang('./tapl/8-2-typing-rules-for-numbers.txt')
TYPEOF = LANG.relation(':')

LANG.rules.each { |_, rule| p rule }

def typeof(expr)
  expr = Infer.expr(expr)
  type, derivation = TYPEOF.once_with_derivation(expr)

  puts
  puts "# #{expr}"
  puts "# #{'-' * expr.to_s.size}"
  puts "# #{type}"
  puts
  Infer.print_derivation(derivation)
  puts
end

typeof 'if (iszero (succ 0)) then 0 else (succ (succ 0))'
typeof 'iszero (succ (if false then (if (iszero (succ 0)) then 0 else (succ 0)) else (pred 0)))'
typeof 'if false then (pred 0) else (if (iszero (succ 0)) then 0 else (succ 0))'
typeof 'if (iszero (succ 0)) then false else true'
typeof 'if (iszero (succ 0)) then false else 0'
