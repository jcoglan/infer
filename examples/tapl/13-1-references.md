# → Unit Ref
# Figure 13-1: References, p166

    import ./11-2-unit-type

    syntax {
      $l ::= ε
           / l $l

      $t ::= ...
           / ref $t
           / !$t
           / $t := $t
           / $l

      $v ::= ...
           / $l

      $T ::= ...
           / Ref $T

      $μ ::= ∅
           / $μ, $l ↦ $v

      $Σ ::= ∅
           / $Σ, $l: $T
    }


## Evaluation

The rules are presented here almost as in the book, with some minor adjustments
that allow the use of auxilliary rules that define the operations on the store
`μ`.

    rule E-App1 {
            ($t1 | $μ) -> ($t1' | $μ')
      --------------------------------------
      (($t1 $t2) | $μ) -> (($t1' $t2) | $μ')
    }

    rule E-App2 {
            ($t2 | $μ) -> ($t2' | $μ')
      --------------------------------------
      (($v1 $t2) | $μ) -> (($v1 $t2') | $μ')
    }

The `[x ↦ y]` operation used here is the beta reduction operation on redexes,
and is currently not defined within out logic language, so this rule gives the
`[x ↦ y]` expression as literal output and does not evaluate further.

    rule E-AppAbs {
      (((λ$x : $T . $t12) $v2) | $μ) -> (([$x ↦ $v2] $t12) | $μ)
    }

This rule relies on the definition of `x ∉ dom y` given later to create new
locations. While the text simply assumes `l` is any location not currently in
use, the rules defined below allow us to generate a specific `l` and produce a
concrete result here.

    rule E-RefV {
                     $l ∉ dom $μ
      -----------------------------------------
      ((ref $v1) | $μ) -> ($l | ($μ, $l ↦ $v1))
    }

    rule E-Ref {
            ($t1 | $μ) -> ($t1' | $μ')
      --------------------------------------
      ((ref $t1) | $μ) -> ((ref $t1') | $μ')
    }

The `μ[l] = v` operation is defined in auxiliary rules below.

    rule E-DerefLoc {
             $μ[$l] = $v
      -------------------------
      ((!$l) | $μ) -> ($v | $μ)
    }

    rule E-Deref {
         ($t1 | $μ) -> ($t1' | $μ')
      --------------------------------
      ((!$t1) | $μ) -> ((!$t1') | $μ')
    }

In the book the following rule is given without the premise, i.e. `μ'` is
replaced with `[l ↦ v2]μ` inline. However, unlike the `[x ↦ y]` operation
representing beta reduction, the operation used here for binding a location in
the store to a value is much easier to define using simple logic rules, and a
definition is given below. This lets us produce a concrete value for the new
store in this rule.

    rule E-Assign {
              [$l ↦ $v2] $μ = $μ'
      ----------------------------------
      (($l := $v2) | $μ) -> (unit | $μ')
    }

    rule E-Assign1 {
               ($t1 | $μ) -> ($t1' | $μ')
      --------------------------------------------
      (($t1 := $t2) | $μ) -> (($t1' := $t2) | $μ')
    }

    rule E-Assign2 {
               ($t2 | $μ) -> ($t2' | $μ')
      --------------------------------------------
      (($v1 := $t2) | $μ) -> (($v1 := $t2') | $μ')
    }

The following rules do not appear in the book but define some of the operations
used above such that we can compute results using them. First, we have rules
defining how to look up the value bound to a store location. Either the location
is the final one in the store and we return its value:

    rule E-Ref-Get-0 {
      ($μ, $l ↦ $v) [$l] = $v
    }

Or, the location is somewhere else in the store and we must recurse:

    rule E-Ref-Get-N {
              $μ[$l1] = $v1
      ---------------------------
      ($μ, $l2 ↦ $v2) [$l1] = $v1
    }

Next, we need rules for assigning a new value to an existing location in the
store; this is the `[l ↦ v]μ` operation. Again, either the label is the last one
in the store and we can simply replace its binding:

    rule E-Ref-Set-0 {
      [$l ↦ $v2] ($μ, $l ↦ $v1) = ($μ, $l ↦ $v2)
    }

Or, we obtain a new inner store by recursing, and combine this modified inner
store with the label we've skipped over.

    rule E-Ref-Set-N {
                  [$l1 ↦ $v1] $μ = $μ'
      ----------------------------------------------
      [$l1 ↦ $v1] ($μ, $l2 ↦ $v2) = ($μ', $l2 ↦ $v2)
    }

Finally, we have a means of generating new locations. The location syntax is
either `ε` or `(l $l)`, creating a simple sequential labelling for locations.
Actually implementing the `dom(s)` function is not hard, but `∉` is trickier
since it relies on asserting things are not equal. In any case, neither is much
help in picking a concrete unused location. So, I've implemented the compound
sentence `l ∉ dom(μ)` here in such a way that it binds `l` to an unused
location.

If the store is empty, we use the zero location:

    rule E-Ref-Bind-0 {
      ε ∉ dom ∅
    }

Otherwise, we use the 'successor' of the last label in the store.

    rule E-Ref-Bind-N {
      (l $l) ∉ dom ($μ, $l ↦ $v)
    }

Labelling is done this way, rather than having locations implicitly labelled
by their order in the store, because it makes comparing locations for equality
much easier in the presence of mutation. If we just returned the length of the
store, we'd need rules for finding the beginning of the store from its
outermost item, counting leftwards from the beginning of the store, which
would require destructuring both the store and the location in lock-step. As
is, we only need to recurse rightwards from the end of the store, and the
location itself is not destructured.


### Examples

    loop -> { (ref unit) | ∅ }
    loop -> { (ref (λx:Unit. x)) | (∅ , ε ↦ unit) }

    loop -> { (! ε) | ((∅ , ε ↦ (λ x : Unit . x)) , (l ε) ↦ unit) }
    loop -> { (! (lε)) | ((∅ , ε ↦ (λ x : Unit . x)) , (l ε) ↦ unit) }
    loop -> { (ε := unit) | ((∅ , ε ↦ (λ x : Unit . x)) , (l ε) ↦ unit) }


## Typing

    rule T-Var {
        ($x : $T) ∈ $Γ
      -----------------
      $Γ | $Σ ⊢ $x : $T
    }

    rule T-Abs {
           ($Γ, $x : $T1) | $Σ ⊢ $t2 : $T2
      -----------------------------------------
      $Γ | $Σ ⊢ (λ$x : $T1 . $t2) : ($T1 → $T2)
    }

    rule T-App {
      $Γ | $Σ ⊢ $t1 : ($T11 → $T12) / $Γ | $Σ ⊢ $t2 : $T11
      ----------------------------------------------------
                    $Γ | $Σ ⊢ ($t1 $t2) : $T12
    }

    rule T-Unit {
      $Γ | $Σ ⊢ unit : Unit
    }

    rule T-Loc {
            $Σ[$l] = $T1
      ------------------------
      $Γ | $Σ ⊢ $l : (Ref $T1)
    }

    rule T-Ref {
            $Γ | $Σ ⊢ $t1 : $T1
      -------------------------------
      $Γ | $Σ ⊢ (ref $t1) : (Ref $T1)
    }

    rule T-Deref {
      $Γ | $Σ ⊢ $t1 : (Ref $T11)
      --------------------------
       $Γ | $Σ ⊢ (! $t1) : $T11
    }

    rule T-Assign {
      $Γ | $Σ ⊢ $t1 : (Ref $T11) / $Γ | $Σ ⊢ $t2 : $T11
      -------------------------------------------------
                $Γ | $Σ ⊢ ($t1 := $t2) : Unit
    }

Typing is mostly done as in the book; the only additions are these rules for
implementing the look-up `Σ[l]` in a similar manner to looking up locations in
the runtime store.

    rule T-Ref-Get-0 {
      ($Σ, $l: $T) [$l] = $T
    }

    rule T-Ref-Get-N {
             $Σ[$l1] = $T1
      --------------------------
      ($Σ, $l2: $T2) [$l1] = $T1
    }


### Examples

    prove { ∅ | ∅ ⊢ (ref unit) : $T }
    prove { ∅ | ∅ ⊢ ((λx: (Ref Unit). (x := unit)) (ref unit)) : $T }
    prove { ∅ | ∅ ⊢ ((λx: (Ref Unit). (!x)) (ref unit)) : $T }

    prove { ∅ | (∅ , ε : (Unit → Unit)) ⊢ ε : $T }


## Exercises

Ex. 13.5.8

A factorial function defined using mutable references:

    (λf: Ref (Nat → Nat).
        f := (λn: Nat.
                 if iszero n
                 then succ 0
                 else times n (!f (pred n)));
        !f)
    (ref (λ_: Nat. 0))

c.f.: Scheme, where letrec relies on define. let cannot create self-referential
functions b/c the scope where the function is created is not the one where the
variable is bound:

    (let ((f (lambda (n) (f ...))))
      (f 0))

    == ((lambda (f) (f 0))
        (lambda (n) (f ...)))
                     ^
              this f is free

This same restriction applies to the lambda calculus without references.
However, letrec using define means the variables share scope:

    (letrec ((f (lambda (n) (f ...))))
      (f 0))

    == ((lambda ()
          (define f (lambda (n) (f ...)))
          (f 0)))

This sharing of scope and sequencing of statements is what allows letrec to work
and is very close to what's going on in the lambda calculus above. The only
addition is that we need to fabricate a reference of the correct type before
assigning a recursive function to it.
