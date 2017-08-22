# B (typed)
# Figure 8-1: Typing rules for booleans, p93

extends ./3-1-booleans

    syntax {
      $T ::= Bool
    }

    rule T-True {
      true : Bool
    }

    rule T-False {
      false : Bool
    }

    rule T-If {
      $t1 : Bool / $t2 : $T / $t3 : $T
      --------------------------------
      (if $t1 then $t2 else $t3) : $T
    }
