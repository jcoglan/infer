require_relative '../lib/infer'

program = Infer::Prolog.program <<-PL
  member(X, [X|_]).
  member(X, [_|Xs]) :- member(X, Xs).

  append([], Ys, Ys).
  append([X|Xs], Ys, [X|Zs]) :- append(Xs, Ys, Zs).

  reverse([], []).
  reverse([X|Xs], Ys) :- reverse(Xs, Zs), append(Zs, [X], Ys).

  reverse2(Xs, Ys) :- reverse(Xs, [], Ys).
  reverse([], Ys, Ys).
  reverse([X|Xs], Acc, Ys) :- reverse(Xs, [X|Acc], Ys).
PL

queries = [
  'member(d, [a,b,c]).',
  'member(a, [a,b,c]).',
  'member(X, [a,b,c]).',

  'append([], [a], Z).',
  'append([a], [b], Z).',
  'append(X, Y, [a, b, c]).',

  'reverse([a, b, c], X).',
  'reverse([a, b, c], [c, B, a]).',
  'reverse([a, b, c], [d, B, a]).',
  'reverse2([a, b, c], X).',
]

queries.each do |query|
  query, vars = Infer::Prolog.query(query)
  states = program.derive(query)

  puts "?- #{query}."

  Infer::Prolog.print_results(states, vars)
end
