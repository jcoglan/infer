ENV['NOSYNTAX'] = '1'

require_relative './_typeof'

lang = Infer.lang('./tapl/16-joins-meets')

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

# if true then {x=0, y=1} else {y=false, z=true}
algo_typeof lang, 'if true then (x=0, (y=(succ 0), ρ)) else (y=false, (z=true, ρ))'

# if true then (λr: {x:Nat, y:Bool}. r.x) else (λs: {y:Top, z:Nat}. s.z)
# : {x:Nat, y:Bool, z:Nat} → Nat
algo_typeof lang, <<-STR
  if true then (λr: (x: Nat, (y: Bool, Rcd)). (r.x)) else (λs: (y: Top, (z: Nat, Rcd)). (s.z))
STR

# (λr: {x:Top}. r.x) {}
# should not typecheck
# algo_typeof lang, '(λr:(x:Top,Rcd). (r.x)) ρ'
