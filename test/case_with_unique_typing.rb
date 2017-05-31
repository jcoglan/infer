require_relative './_typeof'

lang = Infer.lang('./tapl/11-10-sums-with-unique-typing.txt')

typeof lang, <<-STR
  case (inl 0 as (Nat + Bool)) of
    inl x ⇒ (iszero x)
    inr y ⇒ (if y then false else true)
STR
