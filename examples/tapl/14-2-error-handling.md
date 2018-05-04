# → error try
# Figure 14-2: Error handling, p174

    import ./14-1-errors

    syntax {
      $t ::= ... / try $t with $t
    }


## Evaluation

    rule E-TryV {
      (try $v1 with $t2) -> $v1
    }

    rule E-TryError {
      (try error with $t2) -> $t2
    }

    rule E-Try {
                     $t1 -> $t1'
      -----------------------------------------
      (try $t1 with $t2) -> (try $t1' with $t2)
    }


## Typing

    rule T-Try {
      $Γ ⊢ $t1 : $T / $Γ ⊢ $t2 : $T
      -----------------------------
      $Γ ⊢ (try $t1 with $t2) : $T
    }


### Examples

    prove {
      ∅ ⊢ (((λx:Nat. (λy:Nat. x)) error)
           ((λz:Nat. z) 0))
        : $T
    }

    prove {
      ∅ ⊢ ((λd: (Nat → Nat). (try (d 0) with 0))
           (λn: Nat.
              (if (iszero n) then error else (pred n))))
        : $T
    }
