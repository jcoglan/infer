ENV['NOSYNTAX'] = '1'

require_relative './_typeof'

lang = Infer.lang('./tapl/16-1-subtype-relation-with-records')

# To prove:
#
#   {x: {a: Nat, b: Nat}, y: {m: Nat}} <:
#       - {x: {a: Nat}, y: {}}
#       - {x: {a: Nat}, y: {m: Nat}}
#       - {x: {a: Nat}}
#       - {y: {}, x: {}}

expr = 'x: (a: Nat, (b: Nat, Rcd)), (y: (m: Nat, Rcd), Rcd)'

types = [
  'Rcd',
  'x: (a: Nat, Rcd), (y: Rcd, Rcd)',
  'x: (a: Nat, Rcd), (y: (m: Nat, Rcd), Rcd)',
  'x: (a: Nat, Rcd), Rcd',
  'y: Rcd, (x: Rcd, Rcd)'
]

types.each do |type|
  smt = Infer.expr("(#{expr}) <: (#{type})")
  p smt

  states = lang.derive(smt)

  states.each do |state|
    puts
    Infer.print_derivation(state.build_derivation)
  end
  2.times { puts }
end
