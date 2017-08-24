# → {} <:
# Figure 15-3: Records and subtyping, p187

extends ./11-7-records
extends ./15-1-simply-typed-lambda-calculus-with-subtyping


## Subtyping

As with the rules `S-Refl`, `S-Trans` and `T-Sub` we saw in figure 15-1, the
rules in 15-3 may work fine for checking a proposed proof, but are not good at
generating proofs for arbitrary record types. Nevertheless it's instructive to
see how they might be implemented within this logic and to examine their
limitations.

The rules `S-RcdWidth`, `S-RcdDepth` and `S-RcdPerm` each describe a distinct
way that one can generate a subtype of a record type:

- We can add more fields to the end of the type
- We can replace the existing member types with subtypes thereof
- We can change the order of the existing fields

Although for a workable implementation it's actually simpler to combine all
these in a single rule, let's look at implementing these on their own to see
what proofs we can generate. Note that some `S-` rules given below will be
commented out so as to avoid ambiguity when this file is executed.

### Record type equality

First, it will be helpful to have some utility rules (prefixed `U-`) for
checking two record types for equality under various predicates. For example, we
may want to check two record types are literally equal, or that one contains
subtypes of the member types of the other. We will implement this by having
rules expressing relations between records involving some variable predicate
symbol `p`.

Recall that from 11-7, we represent record types recursively, as either `Rcd`
(the empty record) or `l: T, R` where `T` is any type and `R` is a record type.

The base case says the empty record is equal to itself under any predicate. The
inductive step says that the type `l: S, R1` is equal to `l: T, R2` under a
predicate `p` if the statement `S p T` can be derived, and then recursively `R1`
is equal to `R2` under the same predicate. Note the matching labels; this means
the records must contain the same fields in the same order.

    rule U-RcdEq-0 {
      Rcd (= $p) Rcd
    }

    rule U-RcdEq-N {
          $S $p $T / $R1 (= $p) $R2
      ----------------------------------
      ($l: $S, $R1) (= $p) ($l: $T, $R2)
    }

### `S-RcdWidth`

Now we can use `U-RcdEq` to implement the other rules. `S-RcdWidth` says that
`S` is a subtype of `T` if `S` is equal to `T` but with more fields added at the
end, that is `T` is a literal prefix of `S`. We'll implement this by comparing
the two types under a predicate called `…`.

    rule S-RcdWidth {
      $T (= …) $S
      -----------
        $S <: $T
    }

`U-RcdEq` needs to know how to compare the types inside the records. For
`S-RcdWidth` the types must be literally equal.

    rule U-RcdPrefixT {
      $T … $T
    }

Also, we need to extend the `(= …)` operation to allow for `S` having more
fields than `T`. This can be done by stating that the empty record is a prefix
of any other record type.

    rule U-RcdPrefixEmpty {
      Rcd (= …) $R
    }

For example, here is a proof of `{x: Nat, y: Nat} <: {x: Nat}` using the above
rules:

    --------- U-RcdPrefixT   ------------------------- U-RcdPrefixEmpty
    Nat … Nat                Rcd (= …) (y : Nat , Rcd)
    -------------------------------------------------- U-RcdEq-N
    (x : Nat , Rcd) (= …) (x : Nat , (y : Nat , Rcd))
    ------------------------------------------------- S-RcdWidth
     (x : Nat , (y : Nat , Rcd)) <: (x : Nat , Rcd)

### `S-RcdDepth`

The rule `S-RcdDepth` says that `S` is a subtype of `T` if both types contain
the same fields but the members of `S` are subtypes of the corresponding members
of `T`. This can be implemented straightforwardly by comparing the two types
under the predicate `<:`.

    rule S-RcdDepth {
      $S (= <:) $T
      ------------
        $S <: $T
    }

Here is a proof of `{x: {a: Nat}, y: Nat} <: {x: {}, y: Nat}`. Note that,
because of its use of `<:` `S-RcdDepth` can use `S-RcdWith` and `S-RcdPerm` to
detect internal subtypes. This proof uses `S-RcdWidth` to show `{a: Nat} <: {}`.

    ------------------------- U-RcdPrefixEmpty     ---------- S-Refl   -------------- U-RcdEq-0
    Rcd (= …) (a : Nat , Rcd)                      Nat <: Nat          Rcd (= <:) Rcd
    ------------------------- S-RcdWidth         -------------------------------------- U-RcdEq-N
     (a : Nat , Rcd) <: Rcd                      (y : Nat , Rcd) (= <:) (y : Nat , Rcd)
     ---------------------------------------------------------------------------------- U-RcdEq-N
         (x : (a : Nat , Rcd) , (y : Nat , Rcd)) (= <:) (x : Rcd , (y : Nat , Rcd))
         -------------------------------------------------------------------------- S-RcdDepth
           (x : (a : Nat , Rcd) , (y : Nat , Rcd)) <: (x : Rcd , (y : Nat , Rcd))

### `S-RcdPerm`

Finally, `S-RcdPerm` says that `S` is a subtype of `T` if its fields are a
permutation of those of `T`, that is both types contain the same fields but
possibly in a different order. For this we won't use `U-RcdEq` since that
requires the fields to be in the same order. Instead, we'll implement
permutation by requiring that the fields of `S` are a subset of the fields of
`T`, and vice-versa. The types being subsets of each other means they contain
the same fields, but possibly in different orders.

    rule S-RcdPerm {
      $S ⊆ $T / $T ⊆ $S
      -----------------
          $S <: $T
    }

The `⊆` relation is implemented as a pair of utility rules. The base case says
the empty record is a subset of all other record types. The inductive step says
that the type `l: T, R1` is a subset of `R2` if the label `l` maps to type `T`
in `R2` (i.e. `R2.l = T`, which relation is defined in 11-7), and recursively
`R1` is a subset of `R2`. This allows the fields to appear in any order.

    rule U-RcdSubset-0 {
      Rcd ⊆ $R
    }

    rule U-RcdSubset-N {
      $R2 . $l = $T / $R1 ⊆ $R2
      -------------------------
         ($l: $T, $R1) ⊆ $R2
    }

Note that the `⊆` relation is talking about the *fields* of record types, not
the types themselves as sets. Although the values that inhabit the type `{}` are
a superset of those inhabiting the type `{x: Nat}`, the fields of the type `{}`
are a subset of those of `{x: Nat}`.

With this rule we can generate a proof of `{x: Nat, y: Nat} <: {y: Nat, x:
Nat}`:

          ------------------------- T-RcdField-0         ------------------------------------- T-RcdField-0   --------------------------------- U-RcdSubset-0         ------------------------- T-RcdField-0         ------------------------------------- T-RcdField-0   --------------------------------- U-RcdSubset-0
          (x : Nat , Rcd) . x = Nat                      (y : Nat , (x : Nat , Rcd)) . y = Nat                Rcd ⊆ (y : Nat , (x : Nat , Rcd))                       (y : Nat , Rcd) . y = Nat                      (x : Nat , (y : Nat , Rcd)) . x = Nat                Rcd ⊆ (x : Nat , (y : Nat , Rcd))
    ------------------------------------- T-RcdField-N   -------------------------------------------------------------------------------------- U-RcdSubset-N   ------------------------------------- T-RcdField-N   -------------------------------------------------------------------------------------- U-RcdSubset-N
    (y : Nat , (x : Nat , Rcd)) . x = Nat                                    (y : Nat , Rcd) ⊆ (y : Nat , (x : Nat , Rcd))                                      (x : Nat , (y : Nat , Rcd)) . y = Nat                                    (x : Nat , Rcd) ⊆ (x : Nat , (y : Nat , Rcd))
    ---------------------------------------------------------------------------------------------------------------------- U-RcdSubset-N                        ---------------------------------------------------------------------------------------------------------------------- U-RcdSubset-N
                                  (x : Nat , (y : Nat , Rcd)) ⊆ (y : Nat , (x : Nat , Rcd))                                                                                                   (y : Nat , (x : Nat , Rcd)) ⊆ (x : Nat , (y : Nat , Rcd))
                                  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- S-RcdPerm
                                                                                                               (x : Nat , (y : Nat , Rcd)) <: (y : Nat , (x : Nat , Rcd))

However, this proof can be simplified - notice it essentially computes the same
thing twice if `S` and `T` are indeed subsets of one another. By writing a few
more rules for permutation rather than relying on the `R.l = T` rule we can
generate a smaller proof. First we say `S <: T` if `S perm T`, and then we
define what `perm` means.

    rule S-RcdPerm {
      $S perm $T
      ----------
       $S <: $T
    }

The `perm` relation defines permutation of fields in a record type. The base
case is that the empty record `Rcd` is a permutation of itself. The inductive
step says that `l: T, R1` is a permutation of `R2` if removing the field `l: T`
from `R2` gives a new type `R3` (i.e. `R2 - (l: T) = R3`), and then recursively
`R1` is a permutation of `R3`.

    rule U-RcdPerm-0 {
      Rcd perm Rcd
    }

    rule U-RcdPerm-N {
      $R2 - ($l: $T) = $R3 / $R1 perm $R3
      -----------------------------------
            ($l: $T, $R1) perm $R2
    }

To make that work, we need to define how to remove a field from a record type if
it exists. In the base case, if the desired field matches the first field in the
type, then we return the rest of the type. In the inductive step, the first
field in the type does not match the desired field and we recurse into the tail.

    rule U-RcdDrop-0 {
      ($l: $T, $R) - ($l: $T) = $R
    }

    rule U-RcdDrop-N {
                $R1 - ($k: $S) = $R2
      ----------------------------------------
      ($l: $T, $R1) - ($k: $S) = ($l: $T, $R2)
    }

The rules yield a simpler proof for permutation:

                --------------------------------- U-RcdDrop-0               --------------------------------- U-RcdDrop-0   ------------ U-RcdPerm-0
                (x : Nat , Rcd) - (x : Nat) = Rcd                           (y : Nat , Rcd) - (y : Nat) = Rcd               Rcd perm Rcd
    --------------------------------------------------------- U-RcdDrop-N   ------------------------------------------------------------ U-RcdPerm-N
    (y : Nat , (x : Nat , Rcd)) - (x : Nat) = (y : Nat , Rcd)                           (y : Nat , Rcd) perm (y : Nat , Rcd)
    ------------------------------------------------------------------------------------------------------------------------ U-RcdPerm-N
                                  (x : Nat , (y : Nat , Rcd)) perm (y : Nat , (x : Nat , Rcd))
                                  ------------------------------------------------------------ S-RcdPerm
                                   (x : Nat , (y : Nat , Rcd)) <: (y : Nat , (x : Nat , Rcd))

### The `S-Trans` problem

Although the given `S-Rcd` rules can be implemented and produce some results,
they cannot work for arbitrary record types. We've seen that although
`S-RcdWidth` and `S-RcdPerm` can be nested inside proofs ending in `S-RcdDepth`
due to its use of `<:`, the rules cannot be arbitrarily nested. In general, we
need to resort to `S-Trans`.

An example of this is the proof of `{x: Nat, y: Nat, z: Nat} <: {y: Nat}` given
in exercise 15.2.1:

    --------------------------- S-RcdPerm   --------------------------- S-RcdWidth
       {x: Nat, y: Nat, z: Nat}                {y: Nat, x: Nat, z: Nat}
    <: {y: Nat, x: Nat, z: Nat}             <: {y: Nat}
    ------------------------------------------------------------------- S-Trans
                    {x: Nat, y: Nat, z: Nat} <: {y: Nat}

This proof requires you to realise there exists a type `{y: Nat, x: Nat, z:
Nat}` that can be used to connect the two types via `S-Trans`. But this requires
thinking *outside the system* (c.f. *Gödel, Escher, Bach*, p36), since `S-Trans`
does not give any mechanism for constructing the connecting type `U`. We need a
different formulation of the subtyping relation that works for any record type.
