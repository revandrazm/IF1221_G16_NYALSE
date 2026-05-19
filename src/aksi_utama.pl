% :- include('facts.pl).
:- include('utils.pl').
:- dynamic(giliran/1).
:- dynamic(kartuPemain/2).
urutanPemain([1,2,3,4,5]).
arah(1).
giliran(1).
kartuPemain(1,['hello', 'hi']).

mainkanKartu(Idx) :-
    giliran(Pemain), urutanPemain(Urutan), h_ListIndexOf(Urutan, Pemain, IdPemain), h_ListLength(Urutan, NPemain), kartuPemain(Pemain, Deck), h_ListLength(Deck, N),
    0 =< Idx, Idx < N,
    h_ListAtIndex(Deck, Idx, Kartu),
    % kartuMainValid(Kartu),
    h_ListRemoveAtIndex(Deck, Idx, Deck2),
    retract(kartuPemain(Pemain,_)), asserta(kartuPemain(Pemain,Deck2)),
    format('~w memainkan kartu: ~w', [Pemain,Kartu]), /*formatCard(Kartu),*/ write('.'), nl,
    arah(Arah), IdPemain2 is (IdPemain+NPemain+Arah) mod NPemain,
    h_ListAtIndex(Urutan, IdPemain2, Pemain2), retract(giliran(_)), asserta(giliran(Pemain2)),
    format('Giliran ~w.', [Pemain2]), !.
    
kartuMainValid(kartu(Warna, Jenis)) :-
    discardTop(kartu(Warna2,Jenis2)),
    Warna=Warna2, Jenis=Jenis2.
