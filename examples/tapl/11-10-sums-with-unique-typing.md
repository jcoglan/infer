# → +
# Figure 11-10: Sums (with unique typing), p135

    import ./11-9-sums

    syntax {
      $t ::= ...
           / inl $t as $T
           / inr $t as $T

      $v ::= ...
           / inl $v as $T
           / inr $v as $T
    }


## Evaluation

    rule E-CaseInl {
      (case (inl $v0 as $T0) of inl $x1 ⇒ $t1 inr $x2 ⇒ $t2) -> ([$x1 ↦ $v0] $t1)
    }

    rule E-CaseInr {
      (case (inr $v0 as $T0) of inl $x1 ⇒ $t1 inr $x2 ⇒ $t2) -> ([$x2 ↦ $v0] $t2)
    }

    rule E-Inl {
                   $t1 -> $t1'
      -------------------------------------
      (inl $t1 as $T2) -> (inl $t1' as $T2)
    }

    rule E-Inr {
                   $t1 -> $t1'
      -------------------------------------
      (inr $t1 as $T2) -> (inr $t1' as $T2)
    }


## Typing

    rule T-Inl {
                    $Γ ⊢ $t1 : $T1
      -------------------------------------------
      $Γ ⊢ (inl $t1 as ($T1 + $T2)) : ($T1 + $T2)
    }

    rule T-Inr {
                    $Γ ⊢ $t1 : $T2
      -------------------------------------------
      $Γ ⊢ (inr $t1 as ($T1 + $T2)) : ($T1 + $T2)
    }


### Examples

    prove {
      ∅ ⊢ (case (inl 0 as (Nat + Bool)) of
            inl x ⇒ (iszero x)
            inr y ⇒ (if y then false else true))
        : $T
    }
