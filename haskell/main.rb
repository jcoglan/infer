require_relative '../lib/infer'

haskell = Infer.lang('./haskell/haskell')

exprs = [
  '∅ ⊢ 4 :: Int',
  '∅ ⊢ ((3 + 4) + (5 + 6)) :: $T',
  '∅ ⊢ (\x -> x) :: $T',
  '∅ ⊢ (\x -> (putStrLn x)) :: $T',
  '∅ ⊢ (>>= getLine) :: $T',
  '∅ ⊢ (do (s <- getLine (t <- getLine (putStrLn (s ++ t))))) :: $T',
  '∅ ⊢ (do (x <- ((fmap read) getLine) (y <- ((fmap read) getLine) (print (x + y))))) :: $T',
  # '∅ ⊢ (do (r <- (return (fmap read)) (x <- (r getLine) (y <- (r getLine) (print (x + y)))))) :: $T',
]

exprs.each do |expr|
  puts expr
  states = haskell.derive(Infer.expr(expr))

  states.each do |state|
    puts
    Infer.print_derivation(state.build_derivation)
    puts
  end
end
