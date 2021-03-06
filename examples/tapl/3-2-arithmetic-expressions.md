# N (untyped)
# Figure 3-2: Arithmetic expressions (NB), p41

    import ./3-1-booleans

    syntax {
      $t ::= ...
           / 0
           / succ $t
           / pred $t
           / iszero $t

      $v ::= ... / $nv

      $nv ::= 0 / succ $nv
    }

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


### Examples

    loop -> { if true then true else false }
    loop -> { if false then true else false }
    loop -> { if (if true then false else true) then true else false }


    loop -> { if true then (if true then false else true) else false }

    loop -> {
      if (if (if true then true else true)
          then false
          else true)
      then true
      else false
    }
