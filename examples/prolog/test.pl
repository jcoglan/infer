% vim: ft=prolog

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

math(X, Y) :- Z is X + Y, number(Z), nonvar(Z), var(K).

truth(X) :- X.

complexterm(X) :-
    nonvar(X),
    functor(X, _, A),
    A  >  0.


%% Examples

?- member(d, [a,b,c]).
?- member(a, [a,b,c]).
?- member(X, [a,b,c]).

?- append([], [a], Z).
?- append([a], [b], Z).
?- append(X, Y, [a, b, c]).

?- reverse([a, b, c], X).
?- reverse([a, b, c], [c, B, a]).
?- reverse([a, b, c], [d, B, a]).
?- reverse2([a, b, c], X).
?- member(a, [a,a,b]).
?- member(a, a(a(b))).

?- 3 is 1+2.
?- 4 is 1+2.
?- X is 3*4.
?- M is mod(7,2).

?- len([a,b,c,d,e,[a,b],g], X).
?- acclen([a, b, c], 0, L).

?- 1+3 =:= 2+2.
?- 1+4 =\= 2+2.
?- 1+4 =:= 2+2.

?- 1+3 = 2+2.
?- 1+3 = 1+3.

?- 1+3 =:= 3+1.
?- 1+3 = 3+1.

?- accmax([1,0,5,4], 0, Max).
?- max([-11,-2,-7,-4,-12], Max).

?- q.
?- s.

?- [a,b,c] == [a|[b,c]].
?- [a,b,c] == a(b(c([]))).

?- (3 =:= 4) == =:=(3,4).

?- atom(a).
?- atom(X).
?- var(X).

?- math(3,4).

?- functor(f(a,b), F, A).
?- functor([a,b,c], X, Y).
?- functor(8, F, A).
?- functor(T, f, 7).
?- arg(2, loves(vincent,X), mia).

?- truth(member(a, [a,b,c])).
?- truth(A is 3+4).

?- complexterm(a(b)).
?- complexterm(a).

?- arg(A, bluth(michael, gob, buster), N).
?- arg(2, bluth(michael, gob, buster), N).
?- arg(A, bluth(michael, gob, buster), buster).
