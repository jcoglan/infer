# → {} <:
# Figure 15-3: Records and subtyping, p187

extends ./11-7-records
extends ./15-1-simply-typed-lambda-calculus-with-subtyping


## Subtyping

    rule S-Rcd {
      $rT <: Rcd
    }

    rule S-RcdSub {
      $rT . $l <: $T / $rT <: $rT2
      ----------------------------
          $rT <: ($l: $T, $rT2)
    }

    rule S-RcdField1 {
              $T1 <: $T2
      --------------------------
      ($l: $T1, $rT) . $l <: $T2
    }

    rule S-RcdField2 {
            $rT . $l2 <: $T2
      ----------------------------
      ($l1: $T1, $rT) . $l2 <: $T2
    }
