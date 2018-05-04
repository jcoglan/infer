# → B List
# Figure 11-13: Lists, p147

    import ./9-1-pure-simply-typed-lambda-calculus
    import ./typed-bool-nat

    syntax {
      $t ::= ...
           / nil[$T]
           / cons[$T] $t $t
           / isnil[$T] $t
           / head[$T] $t
           / tail[$T] $t

      $v ::= ...
           / nil[$T]
           / cons[$T] $v $v

      $T ::= ...
           / List $T
    }


## Evaluation

    rule E-Cons1 {
                     $t1 -> $t1'
      -----------------------------------------
      (cons[$T] $t1 $t2) -> (cons[$T] $t1' $t2)
    }

    rule E-Cons2 {
                     $t2 -> $t2'
      -----------------------------------------
      (cons[$T] $v1 $t2) -> (cons[$T] $v1 $t2')
    }

    rule E-IsnilNil {
      (isnil[$S] (nil[$T])) -> true
    }

    rule E-IsnilCons {
      (isnil[$S] (cons[$T] $v1 $v2)) -> false
    }

    rule E-Isnil {
                  $t1 -> $t1'
      -----------------------------------
      (isnil[$T] $t1) -> (isnil[$T] $t1')
    }

    rule E-HeadCons {
      (head[$S] (cons[$T] $v1 $v2)) -> $v1
    }

    rule E-Head {
                 $t1 -> $t1'
      ---------------------------------
      (head[$T] $t1) -> (head[$T] $t1')
    }

    rule E-TailCons {
      (tail[$S] (cons[$T] $v1 $v2)) -> $v2
    }

    rule E-Tail {
                 $t1 -> $t1'
      ---------------------------------
      (tail[$T] $t1) -> (tail[$T] $t1')
    }


### Examples

    loop -> { nil[Nat] }
    loop -> { cons[Nat] 0 (nil[Nat]) }
    loop -> { cons[Nat] (pred (succ 0)) (nil[Nat]) }

    loop -> {
      cons[Nat] (if (iszero 0) then (succ 0) else 0)
                (cons[Nat] (pred (succ 0))
                           (nil[Nat]))
    }

    loop -> {
      head[Nat] (cons[Nat] (if (iszero 0) then (succ 0) else 0)
                           (cons[Nat] (pred (succ 0))
                                      (nil[Nat])))
    }

    loop -> {
      tail[Nat] (cons[Nat] (if (iszero 0) then (succ 0) else 0)
                           (cons[Nat] (pred (succ 0))
                                      (nil[Nat])))
    }

    loop -> {
      head[Nat] (tail[Nat] (cons[Nat] (if (iszero 0) then (succ 0) else 0)
                                      (cons[Nat] (pred (succ 0))
                                                 (nil[Nat]))))
    }


## Typing

    rule T-Nil {
      $Γ ⊢ (nil[$T1]) : (List $T1)
    }

    rule T-Cons {
      $Γ ⊢ $t1 : $T1 / $Γ ⊢ $t2 : (List $T1)
      --------------------------------------
      $Γ ⊢ (cons[$T1] $t1 $t2) : (List $T1)
    }

    rule T-Isnil {
          $Γ ⊢ $t1 : (List $T11)
      -----------------------------
      $Γ ⊢ (isnil[$T11] $t1) : Bool
    }

    rule T-Head {
          $Γ ⊢ $t1 : (List $T11)
      ----------------------------
      $Γ ⊢ (head[$T11] $t1) : $T11
    }

    rule T-Tail {
            $Γ ⊢ $t1 : (List $T11)
      -----------------------------------
      $Γ ⊢ (tail[$T11] $t1) : (List $T11)
    }


### Examples

    prove { ∅ ⊢ (nil[Bool]) : $T }
    prove { ∅ ⊢ (cons[Bool] true (cons[Bool] false (nil[Bool]))) : $T }
    prove { ∅ ⊢ (cons[Bool] (if true then false else true) (cons[Bool] false (nil[Bool]))) : $T }
    prove { ∅ ⊢ (λx:Bool. (cons[Bool] (if x then x else false) (nil[Bool]))) : $T }
    prove { ∅ ⊢ (cons[(Bool → Bool)] (λx:Bool. x) (nil[(Bool → Bool)])) : $T }
