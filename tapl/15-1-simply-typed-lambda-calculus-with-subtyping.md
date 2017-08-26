# → <: Top
# Figure 15-1: Simply typed lambda calculus with subtyping (λ<:), p186

extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-bool-nat

    syntax {
      $T ::= ... / Top
    }


## Subtyping

The subtyping rules given in the book are a reasonable expression of the
reflexivity and transitivity of subtyping; all types are subtypes of themselves:

    # rule S-Refl {
      $S <: $S
    }

And if there exists some type `U` such that `S <: U` and `U <: T`, then `S` is a
subtype of `T`.

    # rule S-Trans {
      $S <: $U / $U <: $T
      -------------------
            $S <: $T
    }

However, these expressions of the rules don't lead to a good implementation,
even in a logic programming environment. The existence of `S-Refl` means that,
in order to avoid generating multiple proofs of the same thing, subtyping rules
for specific types must include clauses to avoid matching exactly equal types.
For example, if we have a rule that says all record types are subtypes of `Rcd`
(i.e. `R <: Rcd`), then `Rcd <: Rcd` is provable in two ways.

For subtyping, this isn't as big a problem as it is for evaluation and typing.
For the latter, we usually want a unique outcome with one proof; we have some
statement `Γ ⊢ t : T` and we're trying to find `T`, which should have a unique
value. With subtyping, we don't usually want to find `T` in `S <: T`, and unlike
for types, `T` will not be unique. We more often just want to *check* that `S <:
T` can be derived for some known `S` and `T`, and finding any one proof of that
is sufficient. We particularly don't want to try deriving `S <: T` with unknown
`S` and `T` as this will explore the search space indefinitely.

However, `S-Trans` poses a bigger problem. If you already know `S`, `U` and `T`,
then this rule lets you check if `S <: T`. However, if `U` is unknown (which it
will be if you're working backwards from the conclusion), this rule does not say
how to find out what it might be; it gives no way of constructing `U`. This is
similar to the problem we solved in 13-1, where we needed additional rules for
creating a previously unused location. This is a general problem with the rules
in this chapter: they're fine for checking a solution, but no good for
constructing one.

Worse, since the three types are not compelled to be distinct, the rule
interacts with `S-Refl` to mean there are infinite ways of proving the same
thing. For example, to prove, `Nat <: Nat` we can say:

    ---------- S-Refl
    Nat <: Nat

Or, we could say:

                        ---------- S-Refl   ---------- S-Refl
                        Nat <: Nat          Nat <: Nat
                        ------------------------------ S-Trans   ---------- S-Refl
                                  Nat <: Nat                     Nat <: Nat
    ---------- S-Refl             ----------------------------------------- S-Trans
    Nat <: Nat                                   Nat <: Nat
    ------------------------------------------------------- S-Trans
                          Nat <: Nat

There is actually an infinite set of these proofs, which poses problems for
implementation. With an implementation that supports laziness, we can attempt to
derive something and see if there's at least one proof of it (which will
hopefully be the simplest one), but the program continuing to explore the space
while it explores other things will slow things down. For example, given these
rules:

    rule S-Refl {
      $S <: $S
    }

    rule S-Trans {
      $S <: $U / $U <: $T
      -------------------
            $S <: $T
    }

    rule S-AB { A <: B }
    rule S-BC { B <: C }
    rule S-CD { C <: D }

Our implementation will scan through 174 proofs of `A <: ?` before it finds one
of `A <: D`. And even then, the first proof it picks is not unique:

                  ------ S-BC   ------ S-CD
                  B <: C        C <: D
    ------ S-AB   -------------------- S-Trans
    A <: B               B <: D
    --------------------------- S-Trans
              A <: D

An equivalent valid and equally-sized proof is:

    ------ S-AB   ------ S-BC
    A <: B        B <: C
    -------------------- S-Trans   ------ S-CD
           A <: C                  C <: D
           ------------------------------ S-Trans
                       A <: D

Weirder still, if you ask it to derive `A <: D` directly it just loops
indefinitely.

So in general, the ambiguity introduced by trying to execute these rules
directly causes a lot of problems. You end up running into situations where
you're trying to derive `S <: T` and in order to do that you first have to
derive something of essentially the same form, so the program loops forever. The
effects of these rules will therefore have to appear implicitly though our
definitions of other subtyping relationships.

Including the `S-Top` rule is fine, however, since it relates to a specific type
and no rules for other types should ever restate directly that anything is a
subtype of `Top`.

    rule S-Top {
      $S <: Top
    }

The `S-Arrow` rule defines subtyping for functions: function type `S` is a
subtype of function type `T` if an `S` can be passed where a `T` is expected.
This requires that the input of `S` is "broader" than the input of `T` (`S`
accepts a superset of the values accepted by `T`), and the output of `S` is
"narrower" (`S` returns a subset of the values returned by `T`).

For example, this should work, assuming `Int <: Num` (integers are a subset of
all numbers):

    (λf: Int → Num. f 0) (g as Num → Int)

The abstraction on `f` will typecheck if only `Ints` are passed to `f`, which is
fine because the argument `g` accepts all numbers. Similarly, `f` is expected to
return a `Num`, which is true of `g` since it returns `Int`, a subtype of `Num`.
The reverse situation should not typecheck:

    (λf: Num → Int. f 0) (g as Int → Num)

This would allow calling, say, `f 3.14`, which would get stuck as `g` only
accepts `Int`.

Given the above problems with subtyping rules, it's worth noting when `S-Arrow`
will work effectively. We've seen that the subtyping rules are better at
checking a proposed solution than at constructing a solution, so this rule will
be effective when applied after the types of the two functions have been
derived.

    rule S-Arrow {
        $T1 <: $S1 / $S2 <: $T2
      --------------------------
      ($S1 → $S2) <: ($T1 → $T2)
    }

Finally, since we have decided to drop `S-Refl`, we'll include specific rules to
say that `Bool` and `Nat` are subtypes of themselves. It might get tedious to
spell this out for every type, but it's easier that putting checks for
inequality in other rules.

    rule S-Bool { Bool <: Bool }
    rule S-Nat  { Nat  <: Nat  }


## Typing

Much like `S-Trans`, the subsumption rule `T-Sub` suffers from infinite looping
behaviour. As a statement of verification, it makes sense: if you can prove `t`
has type `S`, and `S` is a subtype of `T`, then `t` also has type `T`.

    # rule T-Sub {
      $Γ ⊢ $t : $S / $S <: $T
      -----------------------
            $Γ ⊢ $t : $T
    }

However, as an implementation, it doesn't reduce the problem: in order to find
`T` in `Γ ⊢ t : T`, you must first find `S` in `Γ ⊢ t :S`, which is essentially
the same problem. Putting the `S <: T` condition first does not help matters,
because typically `S` and `T` are both unknown when that term is unified.

Therefore we will need to find ways to work the effects of this into other
rules, as we'll see in 16-3, algorithmic typing.
