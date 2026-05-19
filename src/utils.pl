h_ListLength([], 0).
h_ListLength([_|T], N) :-
    h_ListLength(T, N2),
    N is N2+1.

h_ListAppendElement([], Item, [Item]).
h_ListAppendElement([H|T], Item, [H|R]) :-
    h_ListAppendElement(T, Item, R).

h_ListAppendList([], X, X).
h_ListAppendList([H|T], X, [H|TResult]) :-
    h_ListAppendList(T, X, TResult).

h_ListReverse(L, R) :- h_ListLength(L, N), h_ListReverse(L, R, N).
h_ListReverse(List, List, 1).
h_ListReverse([H|T], R, N) :-
    N > 1,
    N2 is N-1,
    h_ListReverse(T, R2, N2),
    h_ListAppendElement(R2, H, R).

h_ListIndexOf([X|_], X, 0).
h_ListIndexOf([_|T], X, N) :-
    h_ListIndexOf(T, X, N2),
    N is N2+1.

h_ListAtIndex(List, Idx, R) :-
    h_ListIndexOf(List, R, Idx).

h_ListInsertAtIndex(List, 0, X, [X|List]).
h_ListInsertAtIndex([H|T], Idx, X, [H|R2]) :-
    Idx > 0,
    Idx2 is Idx-1,
    h_ListInsertAtIndex(T, Idx2, X, R2).

h_ListRemoveAtIndex([_|T], 0, T).
h_ListRemoveAtIndex([H|T], Idx, [H|R]) :-
    Idx > 0,
    Idx2 is Idx-1,
    h_ListRemoveAtIndex(T, Idx2, R).

h_ListGetElement([E|_], 0, E).
h_ListGetElement([_|T], I, Element) :-
    I > 0,
    I1 is I - 1,
    h_ListGetElement(T, I1, Element).

h_ListIsMember(X, [X|_]).
h_ListIsMember(X, [_|T]) :-
    h_ListIsMember(X, T).

h_FormatCard(kartu(Warna,Jenis)) :-
	format('~w-~w',[Warna,Jenis]).

h_Shuffle([], []).
h_Shuffle(Awal, [ElemenAcak|SisaAcak]) :-
    h_ListLength(Awal, Panjang),
    random(0, Panjang, Index),
    h_ListGetElement(Awal, Index, ElemenAcak),
    h_ListRemoveAtIndex(Awal, Index, AwalSisa),
    h_Shuffle(AwalSisa, SisaAcak).

testInit :-
    retractall(giliran(_)),
    retractall(urutan_pemain(_)),
    retractall(arah_permainan(_)),
    retractall(kartu_pemain(_, _)),
    retractall(discard_top(_)),
    retractall(deck(_)),

    asserta(giliran(player1)),
    asserta(urutan_pemain([player1, player2, player3])),
    asserta(arah_permainan(kiri)),
    asserta(kartu_pemain(player1, [])),
    asserta(kartu_pemain(player2, [])),
    asserta(kartu_pemain(player3, [])),
    asserta(discard_top(kartu(merah, 5))),

    loadKartu(Dek),
    asserta(deck(Dek)).

