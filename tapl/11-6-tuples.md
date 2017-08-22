# → {}
# Figure 11-6: Tuples, p128

# extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-lambda-booleans-and-numbers

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
           / $u . $i

      $uv ::= τ / $v, $uv

      $v ::= ... / $uv

      # The type of a tuple is either the empty-tuple type Tpl, or some other
      # type preceding a tuple type.

      $uT ::= Tpl / $T, $uT

      $T ::= ... / $uT
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

E-Tuple must also be expressed as a base case and an inductive step. If the
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


## Typing

Whereas the book defines T-Tuple iteratively, we define it as two recursive
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

Just as for E-ProjTuple, we need to define T-Proj recursively. The type of the
first element is just the type of that term:

    rule T-Proj-0 {
            $Γ ⊢ $t0 : $T0
      --------------------------
      $Γ ⊢ (($t0, $u) . 0) : $T0
    }

The type of any non-zero index is the type found by recursing once on the
structure of the tuple and the index, effectively stepping one place into the
tuple and subtracting 1 from the index.

    rule T-Proj-N {
            $Γ ⊢ ($u . $i) : $T
      ------------------------------
      $Γ ⊢ (($t0, $u) . (+ $i)) : $T
    }
