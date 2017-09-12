% vim: ft=prolog


%% → (typed)
%% Figure 9-1: Pure simply typed lambda calculus (λ→), p103

% T-Var
type(G, X, T) :- var_type(G, X, T).
var_type([[X, T] | _], X, T) :- !.
var_type([_ | G], X, T) :- var_type(G, X, T).

% T-Abs
type(G, λ(X, T1, Body), arrow(T1, T2)) :-
    type([[X, T1] | G], Body, T2).

% T-App
% type(G, app(X, Y), T2) :-
%     type(G, X, arrow(T1, T2)),
%     type(G, Y, T1).


%% B (typed)
%% Figure 8-1: Typing rules for booleans (B), p93

% T-True
type(_, true, bool).

% T-False
type(_, false, bool).

% T-If (modified for subtyping)
type(G, if(T1, T2, T3), Type) :-
    type(G, T1, bool),
    type(G, T2, Type2),
    type(G, T3, Type3),
    join(Type2, Type3, Type).


%% B N (typed)
%% Figure 8-2: Typing rules for numbers (NB), p93

% T-Zero
type(_, 0, nat).

% T-Succ
type(G, succ(T1), nat) :- type(G, T1, nat).

% T-Pred
type(G, pred(T1), nat) :- type(G, T1, nat).

% T-IsZero
type(G, iszero(T1), bool) :- type(G, T1, nat).


%% → {}
%% Figure 11-7: Records, p129

% record values: rec([[label, term], [label, term], ...])
% record types:  rcd([[label, type], [label, type], ...])

% T-Rcd
type(_, rec([]), rcd([])).
type(G, rec([[Label, Term] | R]), rcd([[Label, Type] | Tail])) :-
    type(G, Term, Type),
    type(G, rec(R), rcd(Tail)).

% T-Proj
type(G, proj(Term, Label), Type) :-
    type(G, Term, R),
    rcd_type(R, Label, Type).

rcd_type(rcd([[Label, Type] | _]), Label, Type).

rcd_type(rcd([_ | R]), Label, Type) :-
    rcd_type(rcd(R), Label, Type).


%% → <: Top
%% Figure 15-1: Simply typed lambda-calculus with subtyping (λ<:), p186

% S-Refl
subtype(S, S) :- !.

% S-Trans
% subtype(S, T) :- subtype(S, U), subtype(U, T).

% S-Top
subtype(_, top).

% S-Arrow
subtype(arrow(S1, S2), arrow(T1, T2)) :-
    subtype(T1, S1),
    subtype(S2, T2).

% T-Sub
% type(G, T1, T) :- type(G, T1, S), subtype(S, T).


%% → {} <:
%% Figure 16-1: Subtype relation with records (compact version), p211

subtype(rcd(_), rcd([])).

subtype(R1, rcd([[Label, Type] | R2])) :-
    rcd_type(R1, Label, S),
    subtype(S, Type),
    subtype(R1, rcd(R2)).


%% → {} <:
%% Figure 16-3: Algorithmic typing, p217

% TA-App
type(G, app(X, Y), T12) :-
    type(G, X, arrow(T11, T12)),
    type(G, Y, T2),
    subtype(T2, T11).


%% Joins and meets

join(S, S, S) :- !.

join(arrow(S1, S2), arrow(T1, T2), arrow(M1, J2)) :-
    meet(S1, T1, M1),
    join(S2, T2, J2),
    !.

join(rcd([]), _, rcd([])) :- !.

join(rcd([[L, S] | R1]), R2, rcd([[L, K] | J])) :-
    rcd_type(R2, L, T),
    join(S, T, K),
    join(rcd(R1), R2, rcd(J)),
    !.

join(rcd([[L, _] | R1]), R2, J) :-
    rcd_not_member(L, R2),
    join(rcd(R1), R2, J),
    !.

join(_, _, top).

meet(S, S, S).

meet(top, T, T).
meet(S, top, S).

meet(arrow(S1, S2), arrow(T1, T2), arrow(J1, M2)) :-
    join(S1, T1, J1),
    meet(S2, T2, M2).

meet(rcd([]), R2, R2).

meet(rcd([[L, S] | R1]), R2, rcd([[L, N] | M])) :-
    rcd_pluck(R2, L, T, R2_),
    meet(S, T, N),
    meet(rcd(R1), R2_, rcd(M)).

meet(S, nil, S).

rcd_pluck(rcd([]), _, nil, rcd([])).

rcd_pluck(rcd([[L, S] | R]), L, S, rcd(R)) :- !.

rcd_pluck(rcd([[K, S] | R]), L, T, rcd([[K, S] | R_])) :-
    rcd_pluck(rcd(R), L, T, rcd(R_)).

rcd_not_member(L, R) :-
    rcd_pluck(R, L, S, _),
    S = nil.

A = A.


/*
    (λf: {x: Nat} → {}. f {x=0}) (λr: {}. {y=true, r})
    % should be {}

    type([], λ(f, arrow(rcd([[x, nat]]), rcd([])), app(f, rec([[x, 0]]))), T)
    type([], λ(r, rcd([]), rec([[y, true]])), T)
    type([], app(λ(f, arrow(rcd([[x, nat]]), rcd([])), app(f, rec([[x, 0]]))), λ(r, rcd([]), rec([[y, true]]))), T)

    type([], if(true, λ(r, rcd([[x,nat], [y,nat]]), proj(r,x)), λ(s, rcd([[y,top], [z,nat]]), proj(s,z))), T)
*/
