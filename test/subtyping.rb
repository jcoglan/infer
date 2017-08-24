ENV['NOSYNTAX'] = '1'

require_relative './_typeof'

lang = Infer.lang('./tapl/15-3-records-and-subtyping')

typeof lang, 'x=0, (y=(succ 0), ρ)'
typeof lang, 'λr: (x: Nat, Rcd). (r.x)'
typeof lang, '(λr: (x: Nat, Rcd). (r.x)) (x=0, ρ)'
typeof lang, '(λr: (x: Nat, Rcd). (r.x)) (x=0, (y=(succ 0), ρ))'
typeof lang, '(λr: (x: Nat, Rcd). (r.x)) (y=true, (x=0, ρ))'

typeof lang, '(λf: ((x: Nat, Rcd) → Rcd). (f (x=0, ρ)))'

typeof lang, '(λr: (x: (b: Nat, Rcd), Rcd). ((r.x).b)) (x=(a=0, (b=0, ρ)), (y=true, ρ))'

# (λf: {x: Nat} → {}. f {x=0}) (λr: {}. {y=true, r})
# (λr: {}. {y=true, r}) {x=0}
# {y=true, x=0}
typeof lang, '(λf: ((x: Nat, Rcd) → Rcd). (f (x=0, ρ))) (λr: Rcd. (y=true, r))'


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
  'y: Rcd, (x: Rcd, Rcd)',
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
