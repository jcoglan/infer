require_relative '../lib/infer'

lang = Infer.lang('./tapl/16-joins-meets')


join = lang.relation('∨', '=')

types = [
  ['Top', 'Top'],
  ['Nat', 'Nat'],
  ['Top', 'Nat'],
  ['Nat', 'Bool'],
  ['x: Nat, Rcd', 'x: Nat, Rcd'],
  ['Nat', 'x: Nat, Rcd'],
  ['x: Nat, Rcd', 'y: Bool, (x: Nat, Rcd)'],
  ['x: Nat, Rcd', 'x: Nat, (y: Bool, Rcd)'],
  ['z: Top, (x: Nat, Rcd)', 'x: Nat, (y: Bool, Rcd)'],
  ['z: Top, (x: Nat, Rcd)', 'x: Bool, (y: Bool, Rcd)'],
]

types.each do |a, b|
  state, type = join.derive(Infer.expr(a), Infer.expr(b))
  Infer.print_derivation(state.build_derivation)
  2.times { puts }
end


join = lang.relation('∧', '=')

types = [
  ['x: Nat, Rcd', 'y: Bool, Rcd'],
  ['x: Nat, (y: Top, Rcd)', 'y: Bool, (z: Nat, Rcd)'],
]

types.each do |a, b|
  state, type = join.derive(Infer.expr(a), Infer.expr(b))
  Infer.print_derivation(state.build_derivation)
  2.times { puts }
end
