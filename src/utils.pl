h_ListLength([], 0).
h_ListLength([H|T], N) :-
    h_ListLength(T, N2), N is N2+1.

h_ListAppend([], Item, [Item]).
h_ListAppend([H|T], Item, [H|R]) :-
    h_ListAppend(T, Item, R).

h_ListReverse(L, R) :- h_ListLength(L, N), h_ListReverse(L, R, N).
h_ListReverse(List, List, 1).
h_ListReverse([H|T], R, N) :-
    N > 1,
    N2 is N-1,
    h_ListReverse(T, R2, N2),
    h_ListAppend(R2, H, R).

h_ListIndexOf([X|T], X, 0).
h_ListIndexOf([H|T], X, N) :-
    h_ListIndexOf(T, X, N2),
    N is N2+1.

h_ListAtIndex(List, Idx, R) :- h_ListIndexOf(List, R, Idx).

h_ListInsertAtIndex(List, 0, X, [X|List]).
h_ListInsertAtIndex([H|T], Idx, X, [H|R2]) :-
    Idx2 is Idx-1,
    h_ListInsertAtIndex(T, Idx2, X, R2).

h_ListRemoveAtIndex([H|T], 0, T).
h_ListRemoveAtIndex([H|T], Idx, [H|R]) :-
    Idx2 is Idx-1,
    h_ListRemoveAtIndex(T, Idx2, R).
