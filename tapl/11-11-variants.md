# → <>
# Figure 11-11: Variants, p136

# extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-lambda-booleans-and-numbers

These rules differ significantly from those presented in the book. We take a
similar approach to 11-6: tuples and 11-7: records, and define the structure of
variant types and case expressions recursively. For example, take the following
expression:

    case (<bar=false> as <foo: Nat, bar: Bool, qux: Nat>) of
      <foo=x> ⇒ x
    | <bar=y> ⇒ if y then 0 else succ 0
    | <qux=z> ⇒ pred (succ z);

In our syntax and rules, the variant type and the clauses of the case have a
recursive structure; `ν` denotes the empty variant type and `;` denotes an empty
clause list.

    case (<bar=false> as (<foo: Nat> (<bar: Bool> (<qux: Nat> ν)))) of
      (<foo=x> ⇒ x
      (<bar=y> ⇒ (if y then 0 else (succ 0))
      (<qux=z> ⇒ (pred (succ z))
      ;)))

Evaluation proceeds by recursing on the clauses until the label matches the
variant value. For example, the above evaluates in one step to:

    case (<bar=false> as (<foo: Nat> (<bar: Bool> (<qux: Nat> ν)))) of
      (<bar=y> ⇒ (if y then 0 else (succ 0))
      (<qux=z> ⇒ (pred (succ z))
      ;))

And then, because the value label now matches the first clause, this is:

    [y ↦ false] (if y then 0 else (succ 0))
    = if false then 0 else (succ 0)

    -> succ 0

Typing works in a similar way, except we need to recurse on both the case
clauses and the variant type. The type's labels must match the clauses' labels
exactly, in the same order, with the appropriate type for each clause's bound
variable. Taking our example again:

    case (<bar=false> as (<foo: Nat> (<bar: Bool> (<qux: Nat> ν)))) of
      (<foo=x> ⇒ x
      (<bar=y> ⇒ (if y then 0 else (succ 0))
      (<qux=z> ⇒ (pred (succ z))
      ;)))

For this to be well-typed, the type of the input (`<bar=false> as ...`) must
match the clauses, and each clause's result must have the same type. We define
this as follows.

Looking at the first element of the variant type, `<foo: Nat>`. The first clause
is `<foo=x> ⇒ x`, so the labels match. If we assume `x` has type `Nat`, then the
type of the result of this clause, which is just `x`, is also `Nat`.

Then we recurse. Since the type of the first result is `Nat`, the type of the
results of all the other clauses must also be `Nat`. Imagine that we pop one
element off the front of the type and the clauses:

    case (<bar=false> as (<bar: Bool> (<qux: Nat> ν))) of
      (<bar=y> ⇒ (if y then 0 else (succ 0))
      (<qux=z> ⇒ (pred (succ z))
      ;))

Again, the leading labels match, but now the first element of the type is `<bar:
Bool>`. Assuming `y` has type `Bool`, we find that `if y then 0 else (succ 0)`
has type `Nat`, as required. Recurse once more:

    case (<bar=false> as (<qux: Nat> ν)) of
      (<qux=z> ⇒ (pred (succ z))
      ;)

The leading labels match, and assuming `z` has type `Nat` gives us type `Nat`
for `pred (succ z)`. Finally we get to the empty case:

    case (<bar=false> as ν) of ;

On its own, this does not have a well-defined type. We say that if the input has
type `ν` and the clause list is empty, then this expression has some type `T`.
Unification will determine a concrete value for `T`, in this case `Nat`.

In practice, the input to the case will not literally be a variant expression,
so we will not be syntactically recursing on the type in place as shown.
Instead, we invent a special operator on terms, `~t`. If term t has type `<l: T>
S`, then `~t` has type `S`. This lets us recurse on the variant type of the
input term without knowing its internal structure.

    syntax {
      # This is a 'case fold', not a term in its own right but just the
      # recursive syntax of the clauses of a case expression

      $cf ::= ; / <$l=$x> ⇒ $t $cf

      $t ::= ...
           / <$l=$t> as $T
           / case $t of $cf
           / ~$t

      # A variant type is either the empty variant ν, or a <label:Type> pair
      # preceding another variant type

      $vT ::= ν / <$l: $T> $vT

      $T ::= ... / $vT
    }


## Evaluation

The single rule presented in the book is here split into two rules, one for
evaluating the result when the leading label in a term matches the label of the
first clause

    rule E-CaseVariant-0 {
      (case (<$l=$v> as $T) of (<$l=$x> ⇒ $t $cf)) -> ([$x ↦ $v] $t)
    }

and another for recursing on the input and clauses

    rule E-CaseVariant-N {
               (case (<$l=$v> as $T) of $cf) -> $v2 
      ------------------------------------------------------
      (case (<$l=$v> as $T) of (<$l1=$x1> ⇒ $t1 $cf)) -> $v2
    }

    rule E-Case {
                                   $t0 -> $t0'
      ---------------------------------------------------------------------
      (case $t0 of (<$l=$x> ⇒ $t $cf)) -> (case $t0' of (<$l=$x> ⇒ $t $cf))
    }

    rule E-Variant {
                   $t -> $t'
      -----------------------------------
      (<$l=$t> as $T) -> (<$l=$t'> as $T)
    }


## Typing

Just as for evaluation, typing of variant expressions is split into a base case
and an inductive step

    rule T-Variant-0 {
                         $Γ ⊢ $t : $T
      -------------------------------------------------
      $Γ ⊢ (<$l=$t> as (<$l: $T> $vT)) : (<$l: $T> $vT)
    }

    rule T-Variant-N {
                   $Γ ⊢ (<$l=$t> as $vT) : $vT
      -----------------------------------------------------
      $Γ ⊢ (<$l=$t> as (<$l1: $T1> $vT)) : (<$l1: $T1> $vT)
    }

This rule is significantly different from the book. Rather than iterating over
the variant type and clauses, we say that if `t0` has type `<l: T1> vT`, and the
first clause under the assumption `x : T1` has type `T`, and the case expression
with one variant type element and clause removed also has type `T`, then the
original expression has type `T`.

    rule T-Case {
      $Γ ⊢ $t0 : (<$l: $T1> $vT) / ($Γ, $x : $T1) ⊢ $t1 : $T / $Γ ⊢ (case (~$t0) of $cf) : $T
      ---------------------------------------------------------------------------------------
                            $Γ ⊢ (case $t0 of (<$l=$x> ⇒ $t1 $cf)) : $T
    }

This rule expresses the idea that an empty clause list, given an empty variant
type input, can take any type.

    rule T-Case-Null {
            $Γ ⊢ $t0 : ν
      -------------------------
      $Γ ⊢ (case $t0 of ;) : $T
    }

This rule encodes the idea of popping one element off the front of a variant
type by applying a special operator to the term carrying that type.

    rule T-Case-Sub {
      $Γ ⊢ $t : (<$l: $T> $vT)
      ------------------------
          $Γ ⊢ (~$t) : $vT
    }
