# → +
# Figure 11-9: Sums, p132

    import ./9-1-pure-simply-typed-lambda-calculus
    import ./typed-bool-nat

    syntax {
      $t ::= ...
           / inl $t
           / inr $t
           / case $t of inl $x ⇒ $t inr $x ⇒ $t

      $v ::= ...
           / inl $v
           / inr $v

      $T ::= ...
           / $T + $T
    }


## Evaluation

    rule E-CaseInl {
      (case (inl $v0) of inl $x1 ⇒ $t1 inr $x2 ⇒ $t2) -> ([$x1 ↦ $v0] $t1)
    }

    rule E-CaseInr {
      (case (inr $v0) of inl $x1 ⇒ $t1 inr $x2 ⇒ $t2) -> ([$x2 ↦ $v0] $t2)
    }

    rule E-Case {
                                            $t0 -> $t0'
      ---------------------------------------------------------------------------------------
      (case $t0 of inl $x1 ⇒ $t1 inr $x2 ⇒ $t2) -> (case $t0' of inl $x1 ⇒ $t1 inr $x2 ⇒ $t2)
    }

    rule E-Inl {
            $t1 -> $t1'
      -----------------------
      (inl $t1) -> (inl $t1')
    }

    rule E-Inr {
            $t1 -> $t1'
      -----------------------
      (inr $t1) -> (inr $t1')
    }


## Typing

    rule T-Inl {
            $Γ ⊢ $t1 : $T1
      ----------------------------
      $Γ ⊢ (inl $t1) : ($T1 + $T2)
    }

    rule T-Inr {
            $Γ ⊢ $t1 : $T2
      ----------------------------
      $Γ ⊢ (inr $t1) : ($T1 + $T2)
    }

    rule T-Case {
      $Γ ⊢ $t0 : ($T1 + $T2) / ($Γ, $x1 : $T1) ⊢ $t1 : $T / ($Γ, $x2 : $T2) ⊢ $t2 : $T
      --------------------------------------------------------------------------------
                    $Γ ⊢ (case $t0 of inl $x1 ⇒ $t1 inr $x2 ⇒ $t2) : $T
    }


### Examples

    prove {
      ∅ ⊢ (case (inl 0) of
            inl x ⇒ (iszero x)
            inr y ⇒ (if y then false else true))
        : $T
    }
