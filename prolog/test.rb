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

  len([a,b,c,d,e,[a,b],g], X).
  acclen([a, b, c], 0, L).
Q

queries.lines.each do |query|
  next if query =~ /\A\s*\z/
  Infer::Prolog.execute_and_print(program, query)
end

__END__

An example:

?- reverse([a, b, c], X).

    ---------------   --------------------     --------------------          --------------------
    reverse([], [])   append([], [c], [c])     append([], [b], [b])          append([], [a], [a])
    --------------------------------------   ------------------------      ------------------------
              reverse([c], [c])              append([c], [b], [c, b])      append([b], [a], [b, a])
              -------------------------------------------------------   ------------------------------
                              reverse([b, c], [c, b])                   append([c, b], [a], [c, b, a])
                              ------------------------------------------------------------------------
                                                   reverse([a, b, c], [c, b, a])

X = [c, b, a]
