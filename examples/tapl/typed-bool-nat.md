    import ./3-1-booleans
    import ./3-2-arithmetic-expressions

    syntax {
      $T ::= ...
           / Bool
           / Nat
    }


## Booleans

    rule T-True {
      $Γ ⊢ true : Bool
    }

    rule T-False {
      $Γ ⊢ false : Bool
    }

    rule T-If {
      $Γ ⊢ $t1 : Bool / $Γ ⊢ $t2 : $T / $Γ ⊢ $t3 : $T
      -----------------------------------------------
            $Γ ⊢ (if $t1 then $t2 else $t3) : $T
    }


## Numbers

    rule T-Zero {
      $Γ ⊢ 0 : Nat
    }

    rule T-Succ {
          $Γ ⊢ $t1 : Nat
      ---------------------
      $Γ ⊢ (succ $t1) : Nat
    }

    rule T-Pred {
          $Γ ⊢ $t1 : Nat
      ---------------------
      $Γ ⊢ (pred $t1) : Nat
    }

    rule T-IsZero {
            $Γ ⊢ $t1 : Nat
      ------------------------
      $Γ ⊢ (iszero $t1) : Bool
    }
