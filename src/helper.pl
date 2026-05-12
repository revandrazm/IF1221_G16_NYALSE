/* HELPER */

/* reverse(A,B)*/
reverseList(Xs, Ys) :-
  reverseList(Xs, [], Ys, Ys).

reverseList([], Ys, Ys, []).
reverseList([X|Xs], Rs, Ys, [_|Bound]) :-
  reverseList(Xs, [X|Rs], Ys, Bound).

/* format kartu */
formatCard(kartu(Warna,Jenis)):-
	format('~w-~w',[Warna, Jenis]).

/* jumlahKartu */
jumlahKartu([],Acc,Acc) :- !.
jumlahKartu([H|T],Acc,Ans) :-
	Acc2 is Acc + 1,
	jumlahKartu(T, Acc2, Ans).
jumlahKartu(List, Ans) :-
	jumlahKartu(List,0,Ans).
