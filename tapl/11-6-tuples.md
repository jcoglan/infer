# → {}
# Figure 11-6: Tuples, p128

    import ./9-1-pure-simply-typed-lambda-calculus
    import ./typed-bool-nat

    syntax {
      # Since we're using {} as part of the metalanguage, and the metalanguage
      # has no means of doing the * or + operators from regular expressions, we
      # are going to define tuples recursively as either the empty tuple τ, or a
      # tuple with another value prepended:

      $u ::= τ / $t, $u

      # Likewise we will need a recursive definition of numbers. A number is
      # either a literal zero, or a number prefixed with a 'successor'
      # operator, +

      $i ::= 0 / + $i

      $t ::= ...
           / $u
           / $t . $i

      $uv ::= τ / $v, $uv

      $v ::= ... / $uv

      # The type of a tuple is either the empty-tuple type Tpl, or some other
      # type preceding a tuple type.

      $Tu ::= Tpl / $T, $Tu

      $T ::= ... / $Tu
    }


## Evaluation

These rules are modified to encode the required arithmetic as inference rules.
Since we have no built-in concept of numbers here, we use an inductive
definition. First, accessing the 0th element of a tuple returns the first
element:

    rule E-ProjTuple-0 {
      (($v0, $uv) . 0) -> $v0
    }

Accessing any non-zero index on a tuple means recursing on the structure of both
the tuple and the index, popping the first element off the tuple and one
successor operation off the index. This increases the number of steps required
to evaluate these expressions, from O(1) to O(N), but the end result is the
same.

    rule E-ProjTuple-N {
      (($v0, $uv) . (+ $i)) -> ($uv . $i)
    }

    rule E-Proj {
           $t1 -> $t1'
      ---------------------
      ($t1.$i) -> ($t1'.$i)
    }

`E-Tuple` must also be expressed as a base case and an inductive step. If the
first element can be evaluated, then do so:

    rule E-Tuple-0 {
            $t1 -> $t1'
      -----------------------
      ($t1, $u) -> ($t1', $u)
    }

Otherwise, evaluate the rest of the tuple. This is very similar to the
evaluation of pairs, except with the syntactic constraint that the operand must
be a tuple.

    rule E-Tuple-N {
             $u -> $u'
      -----------------------
      ($v1, $u) -> ($v1, $u')
    }


## Examples

    loop -> { τ }
    loop -> { 0, τ }
    loop -> { (iszero (pred (succ 0))), ((if false then 0 else (succ 0)), τ) }
    loop -> { ((iszero (pred (succ 0))), ((if false then 0 else (succ 0)), τ)) . (+0) }


## Typing

Whereas the book defines `T-Tuple` iteratively, we define it as two recursive
rules. The empty tuple has the "empty" type `Tpl`, and a non-empty tuple has a
type constructed by combining the type of the first element with the type of the
rest of the tuple.

    rule T-Tuple-0 {
      $Γ ⊢ τ : Tpl
    }

    rule T-Tuple-N {
      $Γ ⊢ $t1 : $T1 / $Γ ⊢ $u2 : $T2
      -------------------------------
        $Γ ⊢ ($t1, $u2) : ($T1, $T2)
    }

We also need to take a recursive approach to `T-Proj`. The rule itself, instead
of using iteration, can be written by saying if `t` has type `Tu`, and the `i`th
element of `Tu` is `T` (denoted `Tu.i = T`), then `t.i` has type `T`.

    rule T-Proj {
      $Γ ⊢ $t : $Tu / $Tu . $i = $T
      -----------------------------
           $Γ ⊢ ($t . $i) : $T
    }

Then we need a pair of rules for looking up indexes within a tuple type. The
first rule gets the first type out if the index is zero:

    rule T-TplField-0 {
      ($T, $Tu) . 0 = $T
    }

And the second one recurses on the structure of the type and the index for
values greater than zero:

    rule T-TplField-N {
            $Tu . $i = $T1
      -------------------------
      ($T2, $Tu) . (+ $i) = $T1
    }


### Examples

    prove { ∅ ⊢ (0, (true, τ)) : $T }
    prove { ∅ ⊢ ((0, (true, τ)) . 0) : $T }
    prove { ∅ ⊢ ((0, (true, τ)) . (+0)) : $T }
    prove { ∅ ⊢ (0, ((if true then (succ 0) else 0), τ)) : $T }
    prove { ∅ ⊢ ((iszero 0), (0, ((if true then (succ 0) else 0), τ))) : $T }
    prove { ∅ ⊢ ((0, (false, ((pred 0), τ))) . (+0)) : $T }
    prove { ∅ ⊢ ((0, (false, ((pred 0), τ))) . (+(+0))) : $T }

    prove { ∅ ⊢ (succ ((0, (false, ((pred 0), τ))) . (+(+0)))) : $T }
