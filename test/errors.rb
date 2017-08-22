require_relative './_evaluate'
require_relative './_typeof'


lang = Infer.lang('./tapl/14-2-error-handling')

typeof lang, '((λx:Nat. (λy:Nat. x)) error) ((λz:Nat. z) 0)'

typeof lang, <<-EXPR
  (λd: (Nat → Nat). (try (d 0) with 0))
  (λn: Nat.
    (if (iszero n) then error else (pred n)))
EXPR


lang = Infer.lang('./tapl/14-3-exceptions-carrying-values')

evaluate lang, '(raise true) (pred (succ 0))'
evaluate lang, '(pred (succ 0)) true'
evaluate lang, '(pred (succ 0)) (raise true)'
evaluate lang, '(raise (pred (succ 0))) (pred (succ 0))'
evaluate lang, 'raise (raise (raise (pred (succ 0))))'
evaluate lang, 'try (succ 0) with h'
evaluate lang, 'try (raise (succ 0)) with h'
