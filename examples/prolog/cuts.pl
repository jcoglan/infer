% vim: ft=prolog

a(X, Y) :- b(X), !, c(Y).
a(X, X) :- b(X), c(X).

b(1).
b(2).
b(3).

c(1).
c(2).
c(3).

p(X, Y) :- a(X, Y), d(Y).

d(2).
d(3).
