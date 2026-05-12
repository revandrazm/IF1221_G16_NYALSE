/* HELPER */

/* reverse(A,B)*/
reverseList(Xs, Ys) :-
  reverseList(Xs, [], Ys, Ys).

reverseList([], Ys, Ys, []).
reverseList([X|Xs], Rs, Ys, [_|Bound]) :-
  reverseList(Xs, [X|Rs], Ys, Bound).
