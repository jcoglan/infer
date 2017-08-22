# Based on 8-1 and 8-2, with context syntax added

extends ./9-1-pure-simply-typed-lambda-calculus

    syntax {
      $t ::= ...
           / true
           / false
           / if $t then $t else $t
           / 0
           / succ $t
           / pred $t
           / iszero $t

      $v ::= ...
           / true
           / false
           / $nv

      $nv ::= 0 / succ $nv

      $T ::= ...
           / Bool
           / Nat
    }


## Booleans

    rule E-IfTrue {
      (if true then $t2 else $t3) -> $t2
    }

    rule E-IfFalse {
      (if false then $t2 else $t3) -> $t3
    }

    rule E-If {
                             $t1 -> $t1'                          # if the condition can reduce
      ---------------------------------------------------------   # then
      (if $t1 then $t2 else $t3) -> (if $t1' then $t2 else $t3)   # reduce it
    }

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

    rule E-Succ {
             $t1 -> $t1'
      -------------------------
      (succ $t1) -> (succ $t1')
    }

    rule E-PredZero {
      (pred 0) -> 0
    }

    rule E-PredSucc {
      (pred (succ $nv1)) -> $nv1
    }

    rule E-Pred {
             $t1 -> $t1'
      -------------------------
      (pred $t1) -> (pred $t1')
    }

    rule E-IszeroZero {
      (iszero 0) -> true
    }

    rule E-IszeroSucc {
      (iszero (succ $nv1)) -> false
    }

    rule E-IsZero {
               $t1 -> $t1'
      -----------------------------
      (iszero $t1) -> (iszero $t1')
    }

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
