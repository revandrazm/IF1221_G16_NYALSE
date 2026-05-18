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

/* Implementasi fungsi nth0 */
nth0Helper(0, [Head|_], Head).

nth0Helper(Index, [_|Tail], Element) :-
    Index > 0,
    IndexBaru is Index - 1,
    nth0Helper(IndexBaru, Tail, Element).

/* Implementasi fungsi length */
lengthHelper([], 0).

lengthHelper([_|Tail], Length) :-
    lengthHelper(Tail, TailLength),
    Length is TailLength + 1.
