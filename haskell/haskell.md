# Haskell

There follows an extremely rough approximation to Haskell's type checker,
written as a logic program. Mostly to explore type inference and syntactic
sugar.

For the most part, we won't need a lot of syntactic checks in this
implementation, but for terms with no internal structure, like variables and
numbers, it's useful to specify their members.

    syntax {
      $x ::= a / b / c / d / e / f / g / h / i / j
           / k / l / m / n / o / p / q / r / s / t
           / u / v / w / x / y / z

      $n ::= 0 / 1 / 2 / 3 / 4 / 5 / 6 / 7 / 8 / 9
    }


## Lambda calculus

This is a minor variation on the simply typed lambda calculus. The major
difference is that the parameter of an abstraction is not annotated with a type;
the type is inferred from use of the parameter in the body.

A variable `x` has type `T` in typing context `Γ` if a binding `x : T` appears
in `Γ`. The meaning of `∈` is defined below.

    rule T-Var {
      ($x : $T) ∈ $Γ
      --------------
       $Γ ⊢ $x :: $T
    }

An abstraction `\x -> t2` has type `T1 → T2` if, in the context `Γ` augmented
with the assumption that `x` has type `T1`, the body `t2` has type `T2`.

    rule T-Abs {
        ($Γ, $x : $T1) ⊢ $t2 :: $T2
      --------------------------------
      $Γ ⊢ (\$x -> $t2) :: ($T1 → $T2)
    }

An application `t1 t2` has type `T2` if the function `t1` has type `T1 → T2` and
the argument `t2` has type `T1`. No subtyping is currently supported, and
neither are type aliases.

    rule T-App {
      $Γ ⊢ $t1 :: ($T1 → $T2) / $Γ ⊢ $t2 :: $T1
      -----------------------------------------
                $Γ ⊢ ($t1 $t2) :: $T2
    }


## Typing context

A typing context `Γ` holds the types of any in-scope abstraction parameters.
Syntactically, a context is either the empty context `∅`, or a context augmented
with a new binding, i.e. `Γ, x : T`.

The binding `x : T` is a member of the context, if this binding appears at the
end of the context, means it was pushed most recently. A cut is used here to
cope with variable shadowing.

    rule T-Var-0 <!> {
      ($x : $T) ∈ ($Γ, $x : $T)
    }

The recursive case searches for `x : T` if it does not appear as the final
element.

    rule T-Var-N {
             ($x1 : $T1) ∈ $Γ
      -----------------------------
      ($x1 : $T1) ∈ ($Γ, $x2 : $T2)
    }


## Type classes

This is a gross hack and just exists to support the few constrained types
defined below. A function `fn` has type `T` if the function has the constrained
type `(C S) ⇒ T` and an instance declaration `instance C S` exists. The idea is
that the type variable `S` appears within `T` and the constraint can be checked
once `S` is instantiated.

    rule T-TypeClass {
      $Γ ⊢ $fn :: ($C $S) ⇒ $T / instance $C $S
      -----------------------------------------
                    $Γ ⊢ $fn :: $T
    }


## Numbers

Numbers have the type `Num p ⇒ p`.

    rule T-Num {
      $Γ ⊢ $n :: (Num $p) ⇒ $p
    }


## Sugar

Now we augment the basic lambda calculus syntax with the capacity for
dynamically-defined sugar. A term `t` has the type `T` if `t` can be rewritten
as `s`, and `s` has the type `T`.

    rule T-Sugar {
      $t ~> $s / $Γ ⊢ $s :: $T
      ------------------------
            $Γ ⊢ $t :: $T
    }


## Infix operators

One instance of syntactic sugar is infix operators; the expression `x + y` can
be rewritten as `(+ x) y`, where have added parentheses because the core
language only defines application of a function to a single argument.

If an `infix` declaration exists for operator `o`, then rewrite `t1 o t2` as `(o
t1) t2`. We don't have `infixl` and `infixr` because all terms in this
implementation are fully parenthesised to show precedence and associativity.

    rule S-Infix {
                infix $o
      ------------------------------
      ($t1 $o $t2) ~> (($o $t1) $t2)
    }


## Do-notation

Do-notation in Haskell rewrites

    do { x <- t1 ; t2... }

as

    t1 >>= \x -> do { t2... }

In our notation, a sequence of actions is written as a nested list, so we write
`do (x <- t1 t2)` where `t2` is a compound expression containing the rest of the
do-block.

    rule S-DoBind <!> {
      (do ($x <- $t1 $t2)) ~> ($t1 >>= (\$x -> (do $t2)))
    }

If the above rule does not match, we fall through and strip off the `do` from a
non-assignment line. It's assumed that this is the last line in the block.

    rule S-DoEnd {
      (do $t) ~> $t
    }


## Built-in types

These `instance` declarations tell us which typeclass each type is an instance
of, and are used with the `T-TypeClass` rule above.

    rule C-Int-Num     { instance Num Int     }
    rule C-Int-Read    { instance Read Int    }
    rule C-Int-Show    { instance Show Int    }
    rule C-IO-Functor  { instance Functor IO  }
    rule C-IO-Monad    { instance Monad IO    }
    rule C-String-Show { instance Show String }


## Function definitions

Finally, a few definitions of prelude functions. Most of these types are copied
verbatim from ghci.

`+` takes two `Num`-compatible types and returns another. It is also an infix
operator.

    rule F-Plus {
      $Γ ⊢ + :: (Num $a) ⇒ ($a → ($a → $a))
    }
    rule I-Plus { infix + }

`++` takes two strings and returns another, and is also an infix operator.
Strictly speaking, this function should have type `[a] → [a] → [a]`, but we
don't have type aliases in this implementation.

    # $Γ ⊢ ++ :: ([$a] → ([$a] → [$a]))

    rule F-Cat {
      $Γ ⊢ ++ :: (String → (String → String))
    }
    rule I-Cat { infix ++ }

`fmap` maps over a functor, for example we can use it to convert the contents of
an `IO` by calling `fmap read io`.

    rule F-Fmap {
      $Γ ⊢ fmap :: (Functor $f) ⇒ (($a → $b) → (($f $a) → ($f $b)))
    }

Now, the monadic functions. `return` lifts a value into an instance of the
required monad. Which monad `m` is required is inferred from context.

    rule F-Return {
      $Γ ⊢ return :: (Monad $m) ⇒ ($a → ($m $a))
    }

Bind, or `>>=`, takes a monadic value, applies a function to its contents, and
returns another monadic value in the same monad holding the result. It is an
infix operator; so desugaring `do { x <- t1 ; t2 }` leads to `t1 >>= \x -> do
t2...`, which further leads to `(>>= t1) (\x -> do t2...)`.

    rule F-Bind {
      $Γ ⊢ >>= :: (Monad $m) ⇒ (($m $a) → (($a → ($m $b)) → ($m $b)))
    }
    rule I-Bind { infix >>= }

`read` takes a string and returns a value of the type required by the calling
context.

    rule F-Read {
      $Γ ⊢ read :: (Read $a) ⇒ (String → $a)
    }

`getLine` is used to read a line from stdin, and as it requires an effect,
returns `IO String`.

    rule F-GetLine {
      $Γ ⊢ getLine :: (IO String)
    }

`putStrLn` is the opposite of `getLine`, it writes a line to stdout and so takes
a string, executes an effect and returns nothing, or `IO ∅`. We use `∅` because
parens are one of the few reserved tokens in this system.

    rule F-PutStrLn {
      $Γ ⊢ putStrLn :: (String → (IO ∅))
    }

Finally, `print` takes any `Show` value and prints it, again returning `IO ()`.

    rule F-Print {
      $Γ ⊢ print :: (Show $a) ⇒ ($a → (IO ∅))
    }
