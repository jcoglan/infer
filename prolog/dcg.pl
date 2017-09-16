% vim: ft=prolog

s        --> simple_s.
s        --> simple_s, conj, s.
simple_s --> np, vp.

np       --> det, n.

vp       --> v, np.
vp       --> v.

det      --> [the].
det      --> [a].

n        --> [woman].
n        --> [man].

v        --> [shoots].

conj     --> [and].
conj     --> [or].
conj     --> [but].
