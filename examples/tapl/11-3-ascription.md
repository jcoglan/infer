# → as
# Figure 11-3: Ascription, p122

    import ./9-1-pure-simply-typed-lambda-calculus

    syntax {
      $t ::= ... / $t as $T
    }

    rule E-Ascribe {
      ($v1 as $T) -> $v1
    }

    rule E-Ascribe1 {
              $t1 -> $t1'
      ---------------------------
      ($t1 as $T) -> ($t1' as $T)
    }

    rule T-Ascribe {
          $Γ ⊢ $t1 : $T
      ---------------------
      $Γ ⊢ ($t1 as $T) : $T
    }


As a derived form (exercise 11.4.1)

    t as T = (λx : T. x) t


Evaluation:

    -------------------------------- E-AppAbs
    ((λx : T. x) v1) -> ([x ↦ v1] x)
                      = v1

        -- this corresponds to E-Ascribe


                  t1 -> t1'
    ------------------------------------- E-App2
    ((λx : T. x) t1) -> ((λx : T. x) t1')

        -- this corresponds to E-Ascribe1


Typing:

      (x : T) ∈ (Γ, x : T)
      -------------------- T-Var
       (Γ, x : T) ⊢ x : T
    ------------------------- T-Abs
    Γ ⊢ (λx : T. x) : (T → T)         Γ ⊢ t1 : T
    -------------------------------------------- T-App
              Γ ⊢ ((λx : T. x) t1) : T

        -- this corresponds to T-Ascribe
