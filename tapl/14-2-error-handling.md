# → error try
# Figure 14-2: Error handling, p174

extends ./14-1-errors

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
