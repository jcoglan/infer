# → (typed)
# Figure 9-1: Pure simply typed lambda-calculus (λ→), p103
# Based on λ (5-3)

    syntax {
      $x ::= a / b / c / d / e / f / g
           / h / i / j / k / l / m / n
           / o / p / q / r / s / t / u
           / v / w / x / y / z

      $t ::= $x
           / λ$x : $T . $t
           / $t $t

      $v ::= λ$x : $T . $t

      $T ::= $T → $T

      $Γ ::= ∅
           / $Γ, $x : $T
    }


## Evaluation

    rule E-App1 {
            $t1 -> $t1'
      -----------------------
      ($t1 $t2) -> ($t1' $t2)
    }

    rule E-App2 {
            $t2 -> $t2'
      -----------------------
      ($v1 $t2) -> ($v1 $t2')
    }

    rule E-AppAbs {
      ((λ$x : $T . $t12) $v2) -> ([$x ↦ $v2] $t12)
    }


## Typing

    rule T-Var {
      ($x : $T) ∈ $Γ
      --------------
       $Γ ⊢ $x : $T
    }

    rule T-Abs {
           ($Γ, $x : $T1) ⊢ $t2 : $T2
      ------------------------------------
      $Γ ⊢ (λ$x : $T1 . $t2) : ($T1 → $T2)
    }

    rule T-App {
      $Γ ⊢ $t1 : ($T11 → $T12) / $Γ ⊢ $t2 : $T11
      ------------------------------------------
                $Γ ⊢ ($t1 $t2) : $T12
    }


These do not appear in the book; they define the `∈` operator sufficiently to
make `T-Var` actually function.

    rule T-Var-0 {
      ($x : $T) ∈ ($Γ, $x : $T)
    }

    rule T-Var-N {
             ($x1 : $T1) ∈ $Γ
      -----------------------------
      ($x1 : $T1) ∈ ($Γ, $x2 : $T2)
    }
