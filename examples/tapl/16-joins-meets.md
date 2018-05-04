    import ./16-3-algorithmic-typing

The following is an extension to the rules of chapter 16, which give rules for
records but not the more basic types `Bool` and `Nat`. Partly, that's because
typing `if` expressions requires finding the *join* of the types of the two
branches, that is the most specific type that is a supertype of both. Here we
give rules for doing that and discover some logic tricks along the way.


## Joins and meets

We'll tackle joins first, because those are what is needed directly by `TA-If`.
We will also need to tackle meets, because finding the join of function types
requires it.

### Joins

All the rules below use cuts. That's because we want to have a fall-through that
says, if no other join can be found, then the join is `Top`. The cuts mean we
stop searching once one of these rules matches.

The first rule is that the join of a type with itself is just that type. This
covers off `Bool` and `Nat` joining with themselves so nothing further needs to
be said about them.

    rule J-Equal <!> {
      $S ∨ $S = $S
    }

For the common supertype of two function types, the input should be the common
*subtype* of the two types' inputs, because function subtyping is contravariant
in the input type. Say you have an `if` expression to select a function to use,
one function takes inputs of type `A` and the other, type `B`. Any values you
subsequently pass in must be compatible with either function: they must be
typable as `A` *and* as `B`. This means the join of the two function types
should have an input that's a subtype of `A` and `B`, i.e. the *meet* of `A` and
`B`. The output type, however, is covariant; the output type of the join is the
join of the output types of the two functions.

    rule J-Arrow <!> {
         $S1 ∧ $T1 = $M1 / $S2 ∨ $T2 = $J2
      ---------------------------------------
      ($S1 → $S2) ∨ ($T1 → $T2) = ($M1 → $J2)
    }

Then we need rules for records. The join of two types should represent whatever
properties the two types have in common. In the case of records this means the
join will have whatever fields appear in both types; if you know you're getting
either a `{x: Bool, y: Nat}` or a `{y: Nat, z: Top}` then you can be sure you'll
have a subtype of at least `{y:Nat}`. The types assigned to the member labels
will recursively be the joins of the types in the original records' fields.

First, we say the join of any record with the empty record `Rcd` is `Rcd`.

    rule J-Rcd-0 <!> {
      Rcd ∨ $R = Rcd
    }

Then we deal with non-empty records by recursing on the structure of the
left-hand type. We go through each field in `R1`, and if the label `l` maps to
type `S` in `R1` and to `T` in `R2`, and `K` is the join of `S` and `T`, then
the join of `R1` and `R2` includes `l: K` and then recursively the join of the
rest of `R1` with `R2`.

    rule J-Rcd-1 <!> {
      $R2 . $l = $T / $S ∨ $T = $K / $R1 ∨ $R2 = $J
      ---------------------------------------------
            ($l: $S, $R1) ∨ $R2 = ($l: $K, $J)
    }

The other case we need to deal with it where the label `l` does not appear in
`R2`, in which case `R2.l = T` in the previous rule cannot be derived. We
express this using a new relation, `l ∉ R`, which we define below. In this case,
we omit the field from the result.

    rule J-Rcd-2 <!> {
      $l ∉ $R2 / $R1 ∨ $R2 = $J
      -------------------------
       ($l: $S, $R1) ∨ $R2 = $J
    }

Finally, the fall-through case: if we could not join the types by one of the
above rules, the join is `Top`. If we add more joining rules, they must appear
before this one.

    rule J-Top {
      $S ∨ $T = Top
    }

### Meets

Meets work a little differently, in particular, not all pairs of types have a
meet, and we do not need cuts on all the rules since there's no fall-through
case: if none of these rules match then no meet can be found.

First, as for joins, the meet of a type with itself is that type. The cut here
prevents other rules matching when the types are literally equal.

    rule M-Equal <!> {
      $S ∧ $S = $S
    }

The meet of `Top` with any type is that type, because all types are a subtype of
`Top`.

    rule M-Top-L { Top ∧ $T  = $T }
    rule M-Top-R { $S  ∧ Top = $S }

The meet of two function types is very similar to finding the join: the input
type of the meet is the *join* of the inputs types of the two functions,
following a similar argument to that given above. The output is covariant.

    rule M-Arrow {
         $S1 ∨ $T1 = $J1 / $S2 ∧ $T2 = $M2
      ---------------------------------------
      ($S1 → $S2) ∧ ($T1 → $T2) = ($J1 → $M2)
    }

Finally, we tackle records. All record types are subtypes of `Rcd`, so the meet
of `Rcd` with any record type is just that type.

    rule M-Rcd-0 {
      Rcd ∧ $R2 = $R2
    }

Then we solve the general case. Whereas for joins we found the intersection of
the fields of the two types, for meets we need the union. The common subtype of
two record types must include at least all the fields of both types, mapped to
types that themselves are common subtypes of the types in the two records. To
calculate the union, we use a relation `R[l] = T, R'`, which looks up the type
for label `l` in `R`, and returns that type and the record with `l: T` removed.
`T` can also take a nil value `⊥` indicating that `l` does not appear in `R`, in
which case `R` and `R'` are the same. We remove the labels found in `R1` from
`R2` so that they are not included twice in the result.

    rule M-Rcd-N {
      $R2[$l] = $T, $R2' / $S ∧ $T = $N / $R1 ∧ $R2' = $M
      ---------------------------------------------------
              ($l: $S, $R1) ∧ $R2 = ($l: $N, $M)
    }

To handle the case where the label is not found and `T` is `⊥`, we need a rule
that says just use the type from `R1`.

    rule M-RcdNil {
      $S ∧ ⊥ = $S
    }

### Finding fields in records

The rule for omitting fields that don't appear in both record types above uses a
relation `l ∉ R`, which means the label `l` does not appear in record type `R`.
This can't easily be expressed directly since we have no way to say "`R.l = T`
cannot be derived", so we need to come up with some new rules to express the
same thing.

We also used a new relation `R[l] = S, R'` in the rules for meets, where the
relation extracts the type bound to a label `l` in record type `R` and returns
the type and a copy of the record with that label removed. This can also return
a nil type `⊥` and an unchanged record if the label does not exist. This differs
from the `R.l = S` relation we've previously used, which only succeeds if `l`
exists, and does not remove it from the record.

We'll define `R[l] = S, R'` first, and then use that to define `l ∉ R`.

Looking up any label in the empty record returns the nil type:

    rule T-RcdKeyNil {
      Rcd[$l] = ⊥ , Rcd
    }

If we look up a label that does exist in the record, we return the corresponding
type, just like in `R.l = T`. This rule uses a cut, which means once we find the
label in a record, we stop trying to use any other rules (in particular, the
rule after this) to match.

    rule T-RcdKeyHit <!> {
      ($l: $T, $R) [$l] = $T, $R
    }

Then we have the recursive case that scans along the record looking for more
matches. If the previous rule did not use a cut, it would be possible via this
rule to derive `Bool`, `Nat` and `⊥` for the value of `S` in `(x: Bool, (x: Nat,
Rcd)) [x] = S`. The cut means only the first of these can be derived.

    rule T-RcdKeyScan {
                 $R[$l] = $T, $R'
      -------------------------------------
      ($k: $S, $R) [$l] = $T, ($k: $S, $R')
    }

It's worth noting why we've introduced a new relation here instead of extending
`R.l = T` to be able to return `⊥`. Allowing that would mean that all the typing
rules that use that relation to look up a field in a record type could now get
this nil value out and use it in a proof, rather than failing to match if the
field is not a member of the record. It means `R.l = T` is always derivable, but
sometimes `T` will be `⊥`, which does not make it very useful as a premise. The
existence of `SA-Top` (`↦ S <: Top`) means any value can be a subtype of `Top`,
so allowing `R.l = ⊥` to be derived would, for example, mean that `(λr: {x:Top}.
r.x) {}` would typecheck.

         --------------------------- TA-Var
         ∅, r: {x:Top} ↦ r : {x:Top}
         --------------------------- TA-Proj                            -------- T-RcdField   ---------- SA-Top
          ∅, r: {x:Top} ↦ r.x : Top                                     {}.x = ⊥              ↦ ⊥ <: Top
    ------------------------------------ TA-Abs   ----------- TA-Rcd    -------------------------------- SA-Rcd
    ∅ ↦ λr: {x:Top}. r.x : {x:Top} → Top          ∅ ↦ {} : {}                   ↦ {} <: {x:Top}
    ------------------------------------------------------------------------------------------- TA-App
                                  ∅ ↦ (λr: {x:Top}. r.x) {} : Top

Allowing `{}.x = ⊥` leads to us deriving `{} <: {x:Top}`, which is definitely
wrong and the program `(λr: {x:Top}. r.x) {}` would certainly crash.

It's a lot more work to say "anything except `⊥` can be a subtype of `Top`"; you
effectively need to enumerate all the valid types and then either use a
syntactic constraint in `SA-Top` or write a version of that rule for each type.
It's easier to introduce a new relation for this particular use than to extend
an existing one and then fix everything that breaks as a result.

One final bit of support we need before defining the `l ∉ R` relation is a rule
for checking if two expressions are equal, which can be expressed simply with a
matching variable:

    rule U-Eq { $a = $a }

Now we can define `l ∉ R`. This rule essentially says that if `R[l] = ⊥` then `l
∉ R`, but it has to say it in a particular way because of how rules are
executed. If the premise here was literally `$R[$l] = ⊥`, it would not work,
because that is derivable for any record and label. That's because `T-RcdKeyHit`
will never match; it says `(l: S, R) [l] = S` and since we've fixed `S` to `⊥`
this leads to `(l: ⊥, R) [l] = ⊥`, which will not match any actual record type
since `⊥` does not appear as a type within a record.  Therefore, the cut in this
rule doesn't come into force, and we can recurse via `T-RcdKeyScan` all the way
down to the empty record and generate that `⊥`.

The solution to this is to instead put a variable on the right-hand side, as in
`R[l] = S`, so that we allow `T-RcdKeyHit` to match and tell us what `S` is and
prevent us reaching the end of the record if the label exists. Once `S` is
known, only then do we assert that it's equal to `⊥`.

    rule T-Rcd-Miss {
      $R[$l] = $S, $R' / $S = ⊥
      -------------------------
               $l ∉ $R
    }

This shows that the question of whether a given statement can be derived depends
on how you ask the question and where you put variables. Saying `R[l] = S`
treats the relation as a function that "returns" a definite value via the
variable `S`, while `R[l] = ⊥` asks where it's at all possible to derive that
statement, which changes which rules are applicable.


### Examples

    prove { Top ∨ Top = $J }
    prove { Nat ∨ Nat = $J }
    prove { Top ∨ Nat = $J }
    prove { Nat ∨ Bool = $J }
    prove { (x: Nat, Rcd) ∨ (x: Nat, Rcd) = $J }
    prove { Nat ∨ (x: Nat, Rcd) = $J }
    prove { (x: Nat, Rcd) ∨ (y: Bool, (x: Nat, Rcd)) = $J }
    prove { (x: Nat, Rcd) ∨ (x: Nat, (y: Bool, Rcd)) = $J }
    prove { (z: Top, (x: Nat, Rcd)) ∨ (x: Bool, (y: Bool, Rcd)) = $J }

    prove { (x: Nat, Rcd) ∧ (y: Bool, Rcd) = $M }
    prove { (x: Nat, (y: Top, Rcd)) ∧ (y: Bool, (z: Nat, Rcd)) = $M }


## Typing

Now that we can calculate joins and meets, we can write typing rules for our
basic types. These are mostly the same as we've seen before, but the rule for
`if` is modified to calculate the join of the two branches.

### Booleans

    rule TA-True  { $Γ ↦ true  : Bool }
    rule TA-False { $Γ ↦ false : Bool }

    rule TA-If {
      $Γ ↦ $t1 : Bool / $Γ ↦ $t2 : $T2 / $Γ ↦ $t3 : $T3 / $T2 ∨ $T3 = $T
      ------------------------------------------------------------------
                    $Γ ↦ (if $t1 then $t2 else $t3) : $T
    }


### Natural numbers

    rule TA-Zero  { $Γ ↦ 0 : Nat  }

    rule TA-Succ {
          $Γ ↦ $t : Nat
      --------------------
      $Γ ↦ (succ $t) : Nat
    }

    rule TA-Pred {
          $Γ ↦ $t : Nat
      --------------------
      $Γ ↦ (pred $t) : Nat
    }

    rule TA-IsZero {
            $Γ ↦ $t : Nat
      -----------------------
      $Γ ↦ (iszero $t) : Bool
    }

### A proof

Here's a proof using the above rules showing that `∅ ↦ if true then {x=0, y=1}
else {y=false, z=true} : {y:Top}`.

    prove {
      ∅ ↦ (if true then (x=0, (y=(succ 0), ρ)) else (y=false, (z=true, ρ))) : $T
    }


                                                                                                                                                                                                               ─────────────────── T-RcdKeyNil
                                                                                                                                                                                                               Rcd [ x ] = ⊥ , Rcd
                                                       ─────────── TA-Zero                                                                                                                        ───────────────────────────────────────────── T-RcdKeyScan
                                                       ∅ ↦ 0 : Nat                                                                                                                                (z : Bool , Rcd) [ x ] = ⊥ , (z : Bool , Rcd)
                                                    ────────────────── TA-Succ   ─────────── TA-Rcd-0                               ─────────────── TA-True   ─────────── TA-Rcd-0   ─────────────────────────────────────────────────────────────────────── T-RcdKeyScan   ───── U-Eq         ──────────────────────────────────────── T-RcdField-0   ──────────────── J-Top   ───────────────────────────────────────── J-Rcd-0
                                                    ∅ ↦ (succ 0) : Nat           ∅ ↦ ρ : Rcd                                        ∅ ↦ true : Bool           ∅ ↦ ρ : Rcd            (y : Bool , (z : Bool , Rcd)) [ x ] = ⊥ , (y : Bool , (z : Bool , Rcd))                ⊥ = ⊥              (y : Bool , (z : Bool , Rcd)) . y = Bool                Nat ∨ Bool = Top         Rcd ∨ (y : Bool , (z : Bool , Rcd)) = Rcd
                              ─────────── TA-Zero   ──────────────────────────────────────── TA-Rcd-N   ──────────────── TA-False   ───────────────────────────────────── TA-Rcd-N   ──────────────────────────────────────────────────────────────────────────────────────────── T-Rcd-Miss   ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── J-Rcd-1
                              ∅ ↦ 0 : Nat           ∅ ↦ (y = (succ 0) , ρ) : (y : Nat , Rcd)            ∅ ↦ false : Bool            ∅ ↦ (z = true , ρ) : (z : Bool , Rcd)                                         x ∉ (y : Bool , (z : Bool , Rcd))                                                                        (y : Nat , Rcd) ∨ (y : Bool , (z : Bool , Rcd)) = (y : Top , Rcd)
    ─────────────── TA-True   ────────────────────────────────────────────────────────────── TA-Rcd-N   ───────────────────────────────────────────────────────────────── TA-Rcd-N                                ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── J-Rcd-2
    ∅ ↦ true : Bool           ∅ ↦ (x = 0 , (y = (succ 0) , ρ)) : (x : Nat , (y : Nat , Rcd))            ∅ ↦ (y = false , (z = true , ρ)) : (y : Bool , (z : Bool , Rcd))                                                                                        (x : Nat , (y : Nat , Rcd)) ∨ (y : Bool , (z : Bool , Rcd)) = (y : Top , Rcd)
    ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── TA-If
                                                                                                                       ∅ ↦ (if true then (x = 0 , (y = (succ 0) , ρ)) else (y = false , (z = true , ρ))) : (y : Top , Rcd)


### Examples

    prove { ∅ ↦ (x=0, (y=(succ 0), ρ)) : $T }
    prove { ∅ ↦ (λr: (x: Nat, Rcd). (r.x)) : $T }
    prove { ∅ ↦ ((λr: (x: Nat, Rcd). (r.x)) (x=0, ρ)) : $T }
    prove { ∅ ↦ ((λr: (x: Nat, Rcd). (r.x)) (x=0, (y=(succ 0), ρ))) : $T }
    prove { ∅ ↦ ((λr: (x: Nat, Rcd). (r.x)) (y=true, (x=0, ρ))) : $T }

    prove { ∅ ↦ ((λf: ((x: Nat, Rcd) → Rcd). (f (x=0, ρ)))) : $T }

    prove {
      ∅ ↦ ((λr: (x: (b: Nat, Rcd), Rcd). ((r.x).b))
           (x=(a=0, (b=0, ρ)), (y=true, ρ)))
        : $T
    }

    # (λf: {x: Nat} → {}. f {x=0}) (λr: {}. {y=true, r})
    # (λr: {}. {y=true, r}) {x=0}
    # {y=true, x=0}
    prove {
      ∅ ↦ ((λf: ((x: Nat, Rcd) → Rcd). (f (x=0, ρ)))
           (λr: Rcd. (y=true, r)))
        : $T
    }

    # if true then {x=0, y=1} else {y=false, z=true}
    prove {
      ∅ ↦ (if true then
              (x=0, (y=(succ 0), ρ))
            else
              (y=false, (z=true, ρ)))
        : $T
    }

    # if true then (λr: {x:Nat, y:Bool}. r.x) else (λs: {y:Top, z:Nat}. s.z)
    # : {x:Nat, y:Bool, z:Nat} → Nat
    prove {
      ∅ ↦ (if true then
              (λr: (x: Nat, (y: Bool, Rcd)). (r.x))
            else
              (λs: (y: Top, (z: Nat, Rcd)). (s.z)))
        : $T
    }

    # (λr: {x:Top}. r.x) {}
    # should not typecheck
    prove { ∅ ↦ ((λr:(x:Top,Rcd). (r.x)) ρ) : $T }
