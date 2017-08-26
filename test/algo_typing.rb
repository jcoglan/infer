ENV['NOSYNTAX'] = '1'

require_relative './_typeof'

lang = Infer.lang('./tapl/16-3-algorithmic-typing')

algo_typeof lang, 'x=0, (y=(succ 0), ρ)'
algo_typeof lang, 'λr: (x: Nat, Rcd). (r.x)'
algo_typeof lang, '(λr: (x: Nat, Rcd). (r.x)) (x=0, ρ)'
algo_typeof lang, '(λr: (x: Nat, Rcd). (r.x)) (x=0, (y=(succ 0), ρ))'
algo_typeof lang, '(λr: (x: Nat, Rcd). (r.x)) (y=true, (x=0, ρ))'

algo_typeof lang, '(λf: ((x: Nat, Rcd) → Rcd). (f (x=0, ρ)))'

algo_typeof lang, '(λr: (x: (b: Nat, Rcd), Rcd). ((r.x).b)) (x=(a=0, (b=0, ρ)), (y=true, ρ))'

# (λf: {x: Nat} → {}. f {x=0}) (λr: {}. {y=true, r})
# (λr: {}. {y=true, r}) {x=0}
# {y=true, x=0}
algo_typeof lang, '(λf: ((x: Nat, Rcd) → Rcd). (f (x=0, ρ))) (λr: Rcd. (y=true, r))'
