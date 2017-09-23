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

  len([], 0).
  len([_|T], N) :- len(T, X), N is X+1.

  acclen([_|T], A, L) :- Anew is A+1, acclen(T,Anew,L).
  acclen([], A, A).

  accmax([H|T], A, Max) :-
      H > A,
      accmax(T, H, Max).

  accmax([H|T], A, Max) :-
      H =< A,
      accmax(T, A, Max).

  accmax([], A, A).

  max(List, Max)  :-
      List  =  [H|_],
      accmax(List, H, Max).

  q :- X = Y, X == Y.
  r(X) :- X == Y.
  s :- r(Y).
PL

queries = <<-Q
  member(d, [a,b,c]).
  member(a, [a,b,c]).
  member(X, [a,b,c]).

  append([], [a], Z).
  append([a], [b], Z).
  append(X, Y, [a, b, c]).

  reverse([a, b, c], X).
  reverse([a, b, c], [c, B, a]).
  reverse([a, b, c], [d, B, a]).
  reverse2([a, b, c], X).
  member(a, [a,a,b]).
  member(a, a(a(b))).

  3 is 1+2.
  4 is 1+2.
  X is 3*4.
  M is mod(7,2).

  len([a,b,c,d,e,[a,b],g], X).
  acclen([a, b, c], 0, L).

  1+3 =:= 2+2.
  1+4 =\\= 2+2.
  1+4 =:= 2+2.

  1+3 = 2+2.
  1+3 = 1+3.

  1+3 =:= 3+1.
  1+3 = 3+1.

  accmax([1,0,5,4], 0, Max).
  max([-11,-2,-7,-4,-12], Max).

  q.
  s.
Q

queries.lines.each do |query|
  next if query =~ /\A\s*\z/
  Infer::Prolog.execute_and_print(program, query)
end

__END__

An example:

?- reverse([a, b, c], X).

    ———————————————   ————————————————————     ————————————————————          ————————————————————
    reverse([], [])   append([], [c], [c])     append([], [b], [b])          append([], [a], [a])
    ——————————————————————————————————————   ————————————————————————      ————————————————————————
              reverse([c], [c])              append([c], [b], [c, b])      append([b], [a], [b, a])
              ———————————————————————————————————————————————————————   ——————————————————————————————
                              reverse([b, c], [c, b])                   append([c, b], [a], [c, b, a])
                              ————————————————————————————————————————————————————————————————————————
                                                   reverse([a, b, c], [c, b, a])

X = [c, b, a]
