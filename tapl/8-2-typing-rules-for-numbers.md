# N (typed)
# Figure 8-2: Typing rules for numbers (p93)

extends ./8-1-typing-rules-for-booleans
extends ./3-2-arithmetic-expressions

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