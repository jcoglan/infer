# → <: Top
# Figure 15-1: Simply typed lambda calculus with subtyping, p186

# extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-lambda-booleans-and-numbers

    syntax {
      $T ::= ... / Top
    }


## Subtyping

    # rule S-Refl {
      $S <: $S
    }

    # rule S-Trans {
      $S <: $U / $U <: $T
      -------------------
            $S <: $T
    }

    rule S-Top {
      $S <: Top
    }

The S-Arrow rule defines subtyping for functions: function type `S` is a subtype
of function type `T` if an `S` can be passed where a `T` is expected. This
requires that the input of `S` is "broader" than the input of `T` (`S` accepts a
superset of the values accepted by `T`), and the output of `S` is "narrower"
(`S` returns a subset of the values returned by `T`).

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

    rule S-Arrow {
        $T1 <: $S1 / $S2 <: $T2
      --------------------------
      ($S1 → $S2) <: ($T1 → $T2)
    }

    rule S-Bool {
      Bool <: Bool
    }

    rule S-Nat {
      Nat <: Nat
    }


## Typing

    rule T-Sub {
      $Γ ⊢ $t : $S / $S <: $T
      -----------------------
            $Γ ⊢ $t : $T
    }
