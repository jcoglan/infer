ENV['NOSYNTAX'] = '1'

require_relative '../lib/infer'

lang = Infer.lang('./tapl/15-3-records-and-subtyping')

exprs = [
  '(x: Nat, Rcd) <: (x: Nat, Rcd)',
  '(x: Nat, (y: Nat, Rcd)) <: (x: Nat, Rcd)',
  '(x: Rcd, (y: Nat, Rcd)) <: (x: Rcd, (y: Nat, Rcd))',
  '(x: (a: Nat, Rcd), (y: Nat, Rcd)) <: (x: Rcd, (y: Nat, Rcd))',
  '(x: (b: Nat, (a: Nat, Rcd)), (y: Nat, Rcd)) <: (x: (a: Nat, (b: Nat, Rcd)), (y: Nat, Rcd))',
  '(x: Nat, (y: Nat, Rcd)) <: (y: Nat, (x: Nat, Rcd))',
  '(x: Nat, (y: Nat, (z: Nat, Rcd))) <: (y: Nat, Rcd)',
]

exprs.each do |expr|
  puts expr
  puts

  states = lang.derive(Infer.expr expr)

  states.take(1).each do |state|
    Infer.print_derivation(state.build_derivation)
    puts
  end
  puts
end
