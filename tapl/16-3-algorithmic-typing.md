# → {} <:
# Figure 16-3: Algorithmic typing, p217

extends ./16-2-algorithmic-subtyping

### Lambda calculus

    rule TA-Var {
      ($x : $T) ∈ $Γ
      --------------
       $Γ ↦ $x : $T
    }

    rule TA-Abs {
           ($Γ, $x : $T1) ↦ $t2 : $T2
      ------------------------------------
      $Γ ↦ (λ$x : $T1 . $t2) : ($T1 → $T2)
    }

In 15-1 we saw that `T-Sub` does not make for a good implementation, since its
premise has the same form as its conclusion and so the unifier just loops trying
to solve the same problem over and over. What's needed is what the books calls a
*syntax-directed* method of folding the effect of `T-Sub` into other rules.

For example, the main reason we care about subtyping at first is that it allows
us to pass an argument into an abstraction when its type doesn't exactly match
the abstraction's parameter type. We can allow this by changing `T-App` to say,
if the abstraction has type `T11 → T12`, and the argument has type `T2`, and
`T2` is a subtype of `T11`, then the application has type `T12`.

    rule TA-App {
      $Γ ↦ $t1 : ($T11 → $T12) / $Γ ↦ $t2 : $T2 / ↦ $T2 <: $T11
      ---------------------------------------------------------
                        $Γ ↦ ($t1 $t2) : $T12
    }

Note that by placing the subtyping premise at the end, we only attempt to derive
it once `T2` and `T11` are known via the first two premises. This means the `<:`
relation is used to check, rather than to construct a solution. Placing the
subtyping premise first causes programs to loop indefinitely.

Other language extensions would need their own modifications. For example, to
allow a value like `{x: 0, y: true}` to be placed inside a `List {x: Nat}`, the
typing rule for `cons` and other list functions would have to be modified to
allow subtypes of the declared type as list elements.

### Records

    rule TA-Rcd-0 {
      $Γ ↦ ρ : Rcd
    }

    rule TA-Rcd-N {
         $Γ ↦ $t : $T / $Γ ↦ $r : $R
      ---------------------------------
      $Γ ↦ ($l = $t, $r) : ($l: $T, $R)
    }

    rule TA-Proj {
      $Γ ↦ $t : $R / $R . $l = $T
      ---------------------------
          $Γ ↦ ($t . $l) : $T
    }
