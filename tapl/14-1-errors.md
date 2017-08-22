# → error
# Figure 14-1: Errors, p172

# extends ./9-1-pure-simply-typed-lambda-calculus
extends ./typed-lambda-booleans-and-numbers

    syntax {
      $t ::= ... / error
    }


## Evaluation

    rule E-AppErr1 {
      (error $t2) -> error
    }

    rule E-AppErr2 {
      ($v1 error) -> error
    }


## Typing

    rule T-Error {
      $Γ ⊢ error : $T
    }
