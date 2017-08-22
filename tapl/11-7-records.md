# → {}
# Figure 11-7: Records, p129

# extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-lambda-booleans-and-numbers

    syntax {
      # Much like for 11-6: tuples, we define records recursively. A record is
      # either the empty record ρ, or a label=term pair preceding another
      # record.

      $r ::= ρ / $l = $t, $r

      $t ::= ...
           / $r
           / $t . $l

      $rv ::= ρ / $l = $v, $rv

      $v ::= ... / $rv

      # The type of a record is either the empty-record type Rcd, or a
      # label:Type pair preceding another record type.

      $rT ::= Rcd / $l: $T, $rT

      $T ::= ... / $rT
    }


## Evaluation

Since our rule description language has no understand of numbers, the matching
of `i` and `j` in E-ProjRcd has to be expressed a different way. We split it
into two rules: first, if the accessor label matches the first label in the
record, we return the first value

    rule E-ProjRcd-0 {
      (($l = $v, $rv) . $l) -> $v
    }

Otherwise, we return the result of performing the label access on the rest of
the record with the first element removed:

    rule E-ProjRcd-N {
            ($rv . $l) -> $v2
      ------------------------------
      (($l1 = $v1, $rv) . $l) -> $v2
    }

    rule E-Proj {
             $t1 -> $t1'
      -------------------------
      ($t1 . $l) -> ($t1' . $l)
    }

Similarly, E-Rcd must be split into two rules. If the first term can be
evaluated, then do so:

    rule E-Rcd-0 {
                 $t1 -> $t1'
      ---------------------------------
      ($l = $t1, $r) -> ($l = $t1', $r)
    }

Otherwise if the first term is a value and the rest of the record can be
evaluated, then do so:

    rule E-Rcd-N {
                  $r -> $r'
      ---------------------------------
      ($l = $v1, $r) -> ($l = $v1, $r')
    }


## Typing

The type of the empty record is `Rcd` while the type of any non-empty record is
a `label:Type` pair for the first label:term pair, combined with the type for
the rest of the record.

    rule T-Rcd-0 {
      $Γ ⊢ ρ : Rcd
    }

    rule T-Rcd-N {
        $Γ ⊢ $t : $T / $Γ ⊢ $r : $R
      ---------------------------------
      $Γ ⊢ ($l = $t, $r) : ($l: $T, $R)
    }

These rules are similar to those for index accesses on tuples, except that the
label does not have recursive structure. If the accessor label matches the first
label in the record, then the type of the access is the type of the first term.

    rule T-Proj-0 {
      $Γ ⊢ ($l = $t, $r) : ($l: $T, $R)
      ---------------------------------
        $Γ ⊢ (($l = $t, $r) . $l) : $T
    }

Otherwise, the type of the access is the result of looking up the accessor
label in the rest of the record with the first item removed.

    rule T-Proj-N {
            $Γ ⊢ ($r . $l) : $T2
      --------------------------------
      $Γ ⊢ (($l1 = $t, $r) . $l) : $T2
    }
