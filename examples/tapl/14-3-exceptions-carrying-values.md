# → exceptions
# Figure 14-3: Exceptions carrying values, p175

    import ./14-2-error-handling

    syntax {
      $t ::= ... / raise $t
    }


## Evaluation

    rule E-AppRaise1 {
      ((raise $v11) $t2) -> (raise $v11)
    }

    rule E-AppRaise2 {
      ($v1 (raise $v21)) -> (raise $v21)
    }

    rule E-Raise {
              $t1 -> $t1'
      ---------------------------
      (raise $t1) -> (raise $t1')
    }

    rule E-RaiseRaise {
      (raise (raise $v11)) -> (raise $v11)
    }

    rule E-TryV {
      (try $v1 with $t2) -> $v1
    }

    rule E-TryRaise {
      (try (raise $v11) with $t2) -> ($t2 $v11)
    }

    rule E-Try {
                     $t1 -> $t1'
      -----------------------------------------
      (try $t1 with $t2) -> (try $t1' with $t2)
    }


### Examples

    loop -> { (raise true) (pred (succ 0)) }
    loop -> { (pred (succ 0)) true }
    loop -> { (pred (succ 0)) (raise true) }
    loop -> { (raise (pred (succ 0))) (pred (succ 0)) }
    loop -> { raise (raise (raise (pred (succ 0)))) }
    loop -> { try (succ 0) with h }
    loop -> { try (raise (succ 0)) with h }


## Typing

    rule T-Exn {
         $Γ ⊢ $t1 : T_exn
      ---------------------
      $Γ ⊢ (raise $t1) : $T
    }

    rule T-Try {
      $Γ ⊢ $t1 : $T / $Γ ⊢ $t2 : (T_exn → $T)
      ---------------------------------------
            $Γ ⊢ (try $t1 with $t2) : $T
    }
