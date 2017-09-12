require_relative './_typeof'

lang = Infer.lang('./tapl/11-9-sums')

typeof lang, 'case (inl 0) of inl x ⇒ (iszero x) inr y ⇒ (if y then false else true)'



__END__

# case (inl 0) of inl x ⇒ (iszero x) inr y ⇒ (if y then false else true)
# ——————————————————————————————————————————————————————————————————————
# Bool

                                           ————————————————————————— T-Var-0        ——————————————————————————— T-Var-0
                                           (x : Nat) ∈ (∅ , x : Nat)                (y : Bool) ∈ (∅ , y : Bool)
           ——————————— T-Zero              ————————————————————————— T-Var          ——————————————————————————— T-Var     ————————————————————————————— T-False   ———————————————————————————— T-True
           ∅ ⊢ 0 : Nat                      (∅ , x : Nat) ⊢ x : Nat                  (∅ , y : Bool) ⊢ y : Bool            (∅ , y : Bool) ⊢ false : Bool           (∅ , y : Bool) ⊢ true : Bool
    —————————————————————————— T-Inl   ————————————————————————————————— T-IsZero    ————————————————————————————————————————————————————————————————————————————————————————————————————————— T-If
    ∅ ⊢ (inl 0) : (Nat + Bool)         (∅ , x : Nat) ⊢ (iszero x) : Bool                                        (∅ , y : Bool) ⊢ (if y then false else true) : Bool
    ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————— T-Case
                                          ∅ ⊢ (case (inl 0) of inl x ⇒ (iszero x) inr y ⇒ (if y then false else true)) : Bool
