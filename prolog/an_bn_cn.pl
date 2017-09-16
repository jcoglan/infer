% vim: ft=prolog

s  -->  ablock(Count),bblock(Count),cblock(Count).

ablock(0)  -->  [].
ablock(NewCount)  -->  [a],ablock(Count),
                       { NewCount is Count + 1 }.

bblock(0)  -->  [].
bblock(NewCount)  -->  [b],bblock(Count),
                       { NewCount is Count + 1 }.

cblock(0)  -->  [].
cblock(NewCount)  -->  [c],cblock(Count),
                       { NewCount is Count + 1 }.
