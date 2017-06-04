require_relative './_typeof'

lang = Infer.lang('./tapl/11-11-variants.txt')

typeof lang, '<foo=0> as (<bar: Bool> (<foo: Nat> ν))'
typeof lang, '~(<foo=0> as (<bar: Bool> (<foo: Nat> ν)))'
typeof lang, '~(~(<foo=0> as (<bar: Bool> (<foo: Nat> ν))))'

typeof lang, <<-STR
  case (<foo=0> as (<foo: Nat> ν)) of (<foo=x> ⇒ x ;)
STR

typeof lang, <<-STR
  case (<bar=false> as (<foo: Nat> (<bar: Bool> (<qux: Nat> ν)))) of
    (<foo=x> ⇒ x
    (<bar=y> ⇒ (if y then 0 else (succ 0))
    (<qux=z> ⇒ (pred (succ z))
    ;)))
STR
