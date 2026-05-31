/* Specific Utils */
h_FormatCard(kartu(Warna,Jenis)) :-
	format('~w-~w',[Warna,Jenis]).

h_Shuffle([], []) :- !.
h_Shuffle(Awal, [ElemenAcak|SisaAcak]) :-
    h_ListLength(Awal, Panjang),
    random(0, Panjang, Indeks),
    h_ListGetElement(Awal, Indeks, ElemenAcak),
    h_ListRemoveAtIndex(Awal, Indeks, AwalSisa),
    h_Shuffle(AwalSisa, SisaAcak).

h_JumlahKartuPemain(Pemain, JumlahKartu) :-
	kartuPemain(Pemain, ListKartu),
	h_ListLength(ListKartu, JumlahKartu).

/* Basic Utils */
insertTail([], X, X).
insertTail([H|T], X, [H|R]) :- insertTail(T, X, R).

cls :- write('\33\[2J').

h_ListLength([], 0) :- !.
h_ListLength([_|T], N) :-
    h_ListLength(T, N2),
    N is N2+1.

h_ListAppendElement([], Elemen, [Elemen]) :- !.
h_ListAppendElement([H|T], Elemen, [H|R]) :-
    h_ListAppendElement(T, Elemen, R).

h_ListAppendList([], X, X) :- !.
h_ListAppendList([H|T], X, [H|THasil]) :-
    h_ListAppendList(T, X, THasil).

h_ListReverse(L, R) :-
    h_ListLength(L, N),
    h_ListReverse(L, R, N).
h_ListReverse([], [], 0) :- !.
h_ListReverse(List, List, 1) :- !.
h_ListReverse([H|T], R, N) :-
    N > 1,
    N2 is N-1,
    h_ListReverse(T, R2, N2),
    h_ListAppendElement(R2, H, R).

h_ListIndexOf([X|_], X, 0) :- !.
h_ListIndexOf([_|T], X, N) :-
    h_ListIndexOf(T, X, N2),
    N is N2+1.

h_ListAtIndex(List, Indeks, R) :-
    h_ListGetElement(List, Indeks, R).

h_ListInsertAtIndex(List, 0, X, [X|List]) :- !.
h_ListInsertAtIndex([H|T], Indeks, X, [H|R]) :-
    Indeks > 0,
    IndeksBerikutnya is Indeks - 1,
    h_ListInsertAtIndex(T, IndeksBerikutnya, X, R).

h_ListRemoveAtIndex([_|T], 0, T) :- !.
h_ListRemoveAtIndex([H|T], Indeks, [H|R]) :-
    Indeks > 0,
    IndeksBerikutnya is Indeks - 1,
    h_ListRemoveAtIndex(T, IndeksBerikutnya, R).

h_ListGetElement([Elemen|_], 0, Elemen) :- !.
h_ListGetElement([_|T], Indeks, Elemen) :-
    Indeks > 0,
    IndeksBerikutnya is Indeks - 1,
    h_ListGetElement(T, IndeksBerikutnya, Elemen).

h_ListIsMember(X, [X|_]) :- !.
h_ListIsMember(X, [_|T]) :-
    h_ListIsMember(X, T).

h_ListGetRandomElement(List, Elemen) :-
	h_ListLength(List, ListLength),
	random(0, ListLength, Indeks),
	h_ListAtIndex(List, Indeks, Elemen).