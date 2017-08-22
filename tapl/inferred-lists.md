# → B List
# Figure 11-13: Lists, p147

extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-bool-nat

    syntax {
      $t ::= ...
           / nil
           / cons $t $t
           / isnil $t
           / head $t
           / tail $t

      $v ::= ...
           / nil
           / cons $v $v

      $T ::= ...
           / List $T
    }


## Typing

    rule T-Nil {
      $Γ ⊢ nil : (List $T1)
    }

    rule T-Cons {
      $Γ ⊢ $t1 : $T1 / $Γ ⊢ $t2 : (List $T1)
      --------------------------------------
         $Γ ⊢ (cons $t1 $t2) : (List $T1)
    }

    rule T-Isnil {
      $Γ ⊢ $t1 : (List $T11)
      -----------------------
      $Γ ⊢ (isnil $t1) : Bool
    }

    rule T-Head {
      $Γ ⊢ $t1 : (List $T11)
      ----------------------
      $Γ ⊢ (head $t1) : $T11
    }

    rule T-Tail {
          $Γ ⊢ $t1 : (List $T11)
      -----------------------------
      $Γ ⊢ (tail $t1) : (List $T11)
    }
