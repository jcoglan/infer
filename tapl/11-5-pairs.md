# → × 
# Figure 11-5: Pairs, p126

# extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-lambda-booleans-and-numbers

    syntax {
      $t ::= ...
           / $t, $t
           / $t.1
           / $t.2

      $v ::= ... / $v, $v

      $T ::= ... / $T × $T
    }


## Evaluation

    rule E-PairBeta1 {
      (($v1, $v2) . 1) -> $v1
    }

    rule E-PairBeta2 {
      (($v1, $v2) . 2) -> $v2
    }

    rule E-Proj1 {
          $t1 -> $t1'
      -------------------
      ($t1.1) -> ($t1'.1)
    }

    rule E-Proj2 {
          $t1 -> $t1'
      -------------------
      ($t1.2) -> ($t1'.2)
    }

    rule E-Pair1 {
             $t1 -> $t1'
      -------------------------
      ($t1, $t2) -> ($t1', $t2)
    }

    rule E-Pair2 {
             $t2 -> $t2'
      -------------------------
      ($v1, $t2) -> ($v1, $t2')
    }


## Typing

    rule T-Pair {
      $Γ ⊢ $t1 : $T1 / $Γ ⊢ $t2 : $T2
      -------------------------------
       $Γ ⊢ ($t1, $t2) : ($T1 × $T2)
    }

    rule T-Proj1 {
      $Γ ⊢ $t1 : ($T11 × $T12)
      ------------------------
         $Γ ⊢ ($t1.1) : $T11
    }

    rule T-Proj2 {
      $Γ ⊢ $t1 : ($T11 × $T12)
      ------------------------
         $Γ ⊢ ($t1.2) : $T12
    }