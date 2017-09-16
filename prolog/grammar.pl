% vim: ft=prolog

s(s(NP, VP))         --> np(NP, A, subj), vp(VP, A).

np(np(DET, N), A, T) --> det(DET, A), n(N, A, T).
np(np(PRO), A, T)    --> pro(PRO, A, T).

vp(vp(V, NP), A)     --> v(V, A), np(NP, _, obj).
vp(vp(V), A)         --> v(V, A).

det(det(W), A)       --> [W], { lex(W, det(A)) }.
n(n(W), A, T)        --> [W], { lex(W, n(A, T)) }.
pro(pro(W), A, T)    --> [W], { lex(W, pro(A, T)) }.
v(v(W), A)           --> [W], { lex(W, v(A)) }.

lex(the,    det(_)).
lex(a,      det(sin)).

lex(woman,  n(sin, _)).
lex(women,  n(plu, _)).
lex(she,    pro(sin, subj)).
lex(her,    pro(sin, obj)).

lex(man,    n(sin, _)).
lex(men,    n(plu, _)).
lex(he,     pro(sin, subj)).
lex(him,    pro(sin, obj)).

lex(shoots, v(sin)).
lex(shoot,  v(plu)).
