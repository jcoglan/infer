# → let
# Figure 11-4: Let binding, p124

    import ./9-1-pure-simply-typed-lambda-calculus
    import ./typed-bool-nat

    syntax {
      $t ::= ... / let $x=$t in $t
    }

    rule E-LetV {
      (let $x=$v1 in $t2) -> ([$x ↦ $v1] $t2)
    }

    rule E-Let {
                      $t1 -> $t1'
      -------------------------------------------
      (let $x=$t1 in $t2) -> (let $x=$t1' in $t2)
    }

    rule T-Let {
      $Γ ⊢ $t1 : $T1 / ($Γ, $x : $T1) ⊢ $t2 : $T2
      -------------------------------------------
            $Γ ⊢ (let $x=$t1 in $t2) : $T2
    }


### Examples

    prove { ∅ ⊢ (let x = 0 in (iszero (succ x))) : $T }

    prove { ∅ ⊢ (λx:Bool. (λy:Bool. (if x then y else false))) : $T }
    prove { ∅ ⊢ (λx:Bool. (λy:Bool. (λx:Nat. x))) : $T }

    prove {
      (∅ , f : (Bool → Bool))
          ⊢ (λx:Bool. (f (if x then false else x)))
          : $T
    }
