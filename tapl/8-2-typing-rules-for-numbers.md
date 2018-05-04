# N (typed)
# Figure 8-2: Typing rules for numbers, p93

    import ./8-1-typing-rules-for-booleans
    import ./3-2-arithmetic-expressions

    syntax {
      $T ::= ... / Nat
    }

    rule T-Zero {
      0 : Nat
    }

    rule T-Succ {
          $t1 : Nat
      ----------------
      (succ $t1) : Nat
    }

    rule T-Pred {
          $t1 : Nat
      ----------------
      (pred $t1) : Nat
    }

    rule T-IsZero {
            $t1 : Nat
      -------------------
      (iszero $t1) : Bool
    }


## Examples

    prove { (if (iszero (succ 0)) then 0 else (succ (succ 0))) : $T }
    prove { (iszero (succ (if false then (if (iszero (succ 0)) then 0 else (succ 0)) else (pred 0)))) : $T }
    prove { (if false then (pred 0) else (if (iszero (succ 0)) then 0 else (succ 0))) : $T }
    prove { (if (iszero (succ 0)) then false else true) : $T }
    prove { (if (iszero (succ 0)) then false else 0) : $T }
