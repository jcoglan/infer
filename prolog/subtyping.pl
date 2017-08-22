% vim: ft=prolog


%% → (typed)
%% Figure 9-1: Pure simply typed lambda calculus (λ→), p103

% T-Var
type(G, X, T) :- var_type(G, X, T).
var_type([[X, T] | _], X, T).
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

% T-If
type(G, if(T1, T2, T3), T) :-
    type(G, T1, bool),
    type(G, T2, T),
    type(G, T3, T).


%% B N (typed)
%% Figure 8-1: Typing rules for numbers (NB), p93

% T-Zero
type(_, 0, nat).

% T-Succ
type(G, succ(T1), nat) :- type(G, T1, nat).

% T-Pred
type(G, pred(T1), nat) :- type(G, T1, nat).

% T-IsZero
type(G, iszero(T1), bool) :- type(G, T1, nat).


%% → <: Top
%% Figure 15-1: Simply typed lambda-calculus with subtyping (λ<:), p186

% S-Refl
% subtype(S, S).

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

% T-App
type(G, app(X, Y), T2) :-
    type(G, X, arrow(T1, T2)),
    type(G, Y, T),
    subtype(T, T1).

subtype(bool, bool).
subtype(nat, nat).


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
    type(G, Term, RT),
    rcd_type(RT, Label, Type).

rcd_type(rcd([[Label, Type] | _]), Label, Type).

rcd_type(rcd([_ | Tail]), Label, Type) :-
    rcd_type(rcd(Tail), Label, Type).


%% → {} <:
%% Figure 15-3: Records and subtyping, p187

subtype(rcd(_), rcd([])).

subtype(Rec, rcd([[Label, Type] | Tail])) :-
    rcd_subtype(Rec, Label, Type),
    subtype(Rec, rcd(Tail)).

rcd_subtype(rcd([[Label, T2] | _]), Label, T1) :-
    subtype(T2, T1).
rcd_subtype(rcd([_ | Tail]), Label, T1) :-
    rcd_subtype(rcd(Tail), Label, T1).

/*
    (λf: {x: Nat} → {}. f {x=0}) (λr: {}. {y=true, r})

    type([], λ(f, arrow(rcd([[x, nat]]), rcd([])), app(f, rec([[x, 0]]))), T)
    type([], λ(r, rcd([]), rec([[y, true]])), T)
    type([], app(λ(f, arrow(rcd([[x, nat]]), rcd([])), app(f, rec([[x, 0]]))), λ(r, rcd([]), rec([[y, true]]))), T)
*/
