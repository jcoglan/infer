require_relative './_evaluate'
require_relative './_typeof'

lang = Infer.lang('./tapl/13-1-references.txt')

evaluate lang, '(ref unit) | ∅'
evaluate lang, '(ref (λx:Unit. x)) | (∅ , ε ↦ unit)'

env = '((∅ , ε ↦ (λ x : Unit . x)) , (l ε) ↦ unit)'

evaluate lang, "(! ε) | #{env}"
evaluate lang, "(! (lε)) | #{env}"
evaluate lang, "(ε := unit) | #{env}"

ref_typeof lang, 'ref unit'
ref_typeof lang, '(λx: (Ref Unit). (x := unit)) (ref unit)'
ref_typeof lang, '(λx: (Ref Unit). (!x)) (ref unit)'

ref_typeof lang, 'ε', '∅', '∅ , ε : (Unit → Unit)'

__END__

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

This sharing of scope and sequencing of statements is what allows letrec to
work and is very close to what's going on in the lambda calculus above. The
only addition is that we need to fabricate a reference of the correct type
before assigning a recursive function to it.
