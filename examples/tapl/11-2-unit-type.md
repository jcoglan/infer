# → Unit
# Figure 11-2: Unit type, p119

    import ./9-1-pure-simply-typed-lambda-calculus

    syntax {
      $t ::= ... / unit

      $v ::= ... / unit

      $T ::= ... / Unit
    }

    rule T-Unit {
      $Γ ⊢ unit : Unit
    }

    rule D-Unit {
      ($t1 ; $t2) = ((λx : Unit. $t2) $t1)    # where x is not a free var in t2
    }


## Further rules for the sugared form, p120

    rule E-Seq {
              $t1 -> $t1'
      ---------------------------
      ($t1 ; $t2) -> ($t1' ; $t2)
    }

    rule E-SeqNext {
      (unit ; $t2) -> $t2
    }

    rule T-Seq {
      $Γ ⊢ $t1 : Unit / $Γ ⊢ $t2 : $T2
      --------------------------------
          $Γ ⊢ ($t1 ; $t2) : $T2
    }
