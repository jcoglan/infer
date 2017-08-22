# → B List
# Figure 11-13: Lists, p147

# extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-lambda-booleans-and-numbers

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