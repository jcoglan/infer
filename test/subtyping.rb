require_relative './_typeof'

lang = Infer.lang('./tapl/15-3-records-and-subtyping.txt')


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
  p states.size

  states.each do |state|
    puts
    Infer.print_derivation(state.build_derivation)
  end

  puts
  puts
end

# To type:
#
#   (λr: {x: Nat}. r.x) {x=0, y=(succ 0)}
