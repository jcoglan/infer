# → {}
# Figure 11-7: Records, p129

extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-bool-nat

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
of `i` and `j` in `E-ProjRcd` has to be expressed a different way. We split it
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

We need to modify `T-Proj` slightly from the version given in the text. Since we
don't have a looping construct, we'll express the type of `t.l` by saying that
if `t` has some record type `rT`, and the type `rT` maps the label `l` to type
`T` (expressed at `rT.l = T`), then `t.l` has type `T`.

    rule T-Proj {
      $Γ ⊢ $t : $rT / $rT . $l = $T
      -----------------------------
           $Γ ⊢ ($t . $l) : $T
    }

Then we need two auxilliary rules to actually look up the binding of a label
within a record type. The first handles the case where a matching label appears
at the front of the type:

    rule T-RcdField-0 {
      ($l: $T, $rT) . $l = $T
    }

And the second recurses. This is much like the `T-Var` rules for looking a
variable up in a typing context.

    rule T-RcdField-N {
             $rT . $l1 = $T1
      ---------------------------
      ($l2: $T2, $rT) . $l1 = $T1
    }
