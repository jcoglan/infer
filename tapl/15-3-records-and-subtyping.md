# → {}
# Figure 15-3: Records and subtyping

extends ./11-7-records
extends ./15-1-simply-typed-lambda-calculus-with-subtyping


## Subtyping

    rule S-Rcd {
      $rT <: Rcd
    }

    rule S-RcdSub {
      ($l <: $T) ∈ $rT / $rT <: $rT2
      ------------------------------
          $rT <: ($l: $T, $rT2)
    }

    rule S-RcdField1 {
               $T2 <: $T1
      ----------------------------
      ($l <: $T1) ∈ ($l: $T2, $rT)
    }

    rule S-RcdField2 {
            ($l1 <: $T1) ∈ $rT
      ------------------------------
      ($l1 <: $T1) ∈ ($l2: $T2, $rT)
    }
