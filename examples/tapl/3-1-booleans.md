# B (untyped)
# Figure 3-1: Booleans (B), p34

    syntax {
      $t ::= true
           / false
           / if $t then $t else $t

      $v ::= true
           / false
    }

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
