# → {} <:
# Figure 16-1: Subtype relation with records (compact version), p211

extends ./11-7-records
extends ./15-1-simply-typed-lambda-calculus-with-subtyping


## Subtyping

In 15-3, we saw how `S-RcdWidth`, `S-RcdDepth` and `S-RcdPerm` can be
implemented as recursive rules, but also that they have limitations for general
use, relying as they do on `S-Trans` to form proofs for arbitrary types. In this
language we see a different formulation that works better for implementation.

### Unifying the rules

The three operations for generating subtypes can be expressed as a single rule:

> A record type `R1` is a subtype of `R2` if, for every field `l: T` in `R2`,
> there exists a corresponding field `l: S` in `R1` where `S` is a subtype of
> `T`.

This allows `R1` to contain fields that are not in `R2` (`S-RcdWidth`), it
allows the members of `R1` to be subtypes of the members of `R2` (`S-RcdDepth`),
and it allows the matching fields to appear in any order (`S-RcdPerm`).

This rule can be expressed as a pair of inductive rules:

- `S-Rcd-0`: All record types are a subtype of the empty record type `Rcd`.
- `S-Rcd-N`: A record type `R1` is a subtype of `l: T, R2` if the type `R1.l`
  (the type associated with label `l` in `R1`) is a subtype of `T`, and `R1` is
  a subtype of `R2`.

Here are the rules expressed symbolically:

    rule S-Rcd-0 {
      $R <: Rcd
    }

    rule S-Rcd-N {
      $R1 . $l = $S / $S <: $T / $R1 <: $R2
      -------------------------------------
              $R1 <: ($l: $T, $R2)
    }

The relation `R.l = S` used to look up the type bound to a label within a record
type is defined in 11-7.

Unlike the book's rules, this implementation can generate proofs for arbitrary
types. This is due to a few things combining to keep the `<:` usable. In the
notes for 15-1 we saw how `S <: T` works best as a check when `S` and `T` are
already known, not to generate `S` or `T` when either is unknown. Assuming we're
trying to derive `$R1 <: ($l: $T, $R2)` as a check, that means `R1`, `l`, `T`
and `R2` are known. The `R.l = S` relation is deterministic, and so running that
premise first means `S` is known before `S <: T` is attempted, so again `<:` is
used as a check on known values.

Indeed, we can use this to derive a proof for the statement from exercise
15.2.1:

          ------------------------------------- T-RcdField-0
          (y : Nat , (z : Nat , Rcd)) . y = Nat
    ------------------------------------------------- T-RcdField-N   ---------- S-Nat   ---------------------------------------------- S-Rcd-0
    (x : Nat , (y : Nat , (z : Nat , Rcd))) . y = Nat                Nat <: Nat         (x : Nat , (y : Nat , (z : Nat , Rcd))) <: Rcd
    ---------------------------------------------------------------------------------------------------------------------------------- S-Rcd-N
                                        (x : Nat , (y : Nat , (z : Nat , Rcd))) <: (y : Nat , Rcd)

One final thing to note is that the rules from the book produce ambiguity:
`S-RcdWidth`, `S-RcdDepth` and `S-RcdPerm` can all be used to derive `{} <: {}`,
as can `S-Refl`. We could modify the rules, for example changing `S-RcdWidth` so
require `S` to be strictly larger than `T` and the other rules to not allow an
empty left-hand-side. But we'd still be able to derive `S <: T` where `S` and
`T` are the same in multiple ways, unless we remove `S-Refl`, or change
`S-RcdDepth` to require at least one type is not literally the same, or
`S-RcdPerm` to require at least one field to be out of order. These changes just
add complexity that doesn't appear necessary given the relative simplicity of
`S-Rcd-N`.
