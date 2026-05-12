:- include('facts.pl').

listAppend([], X, X).
listAppend([H|T], X, [H|TResult]) :- listAppend(T, X, TResult).

getElement([E|_], 0, E).
getElement([_|T], I, Element) :-
    I > 0,
    I1 is I - 1,
    getElement(T, I1, Element).

getLenght([], 0).
getLenght([_|T], L) :-
    getLenght(T, L1),
    L is L1 + 1.

deleteElement([_|T], 0, T).
deleteElement([E|T], I, [E|TNew]) :-
    I > 0,
    I1 is I - 1,
    deleteElement(T, I1, TNew).

insertAt(TAwal, 0, E, [E|TAwal]).
insertAt([H|T], I, E, [H|TResult]):-
    I > 0,
    I1 is I - 1,
    insertAt(T, I1, E, TResult).

kombinasiSatuWarna(_, [], []).
kombinasiSatuWarna(Warna, [Jenis|SisaJenis], [kartu(Warna, Jenis)|BagianHasil]) :-
    kombinasiSatuWarna(Warna, SisaJenis, BagianHasil).

kombinasiSemuaWarna([], _, []).
kombinasiSemuaWarna([Warna|SisaWarna], Jenis, HasilAkhir) :-
    kombinasiSatuWarna(Warna, Jenis, HasilSatuWarna),
    kombinasiSemuaWarna(SisaWarna, Jenis, HasilSementara),
    listAppend(HasilSementara, HasilSatuWarna, HasilAkhir).

% Convert fakta kartu ke list
loadKartu(ListKartu):-
    warnaDasar(ListWarna),
    jenisKartu(ListJenis),
    kartuHitam(ListKartuHitam),
    kombinasiSemuaWarna(ListWarna, ListJenis, ListKartuWarna),
    listAppend(ListKartuHitam, ListKartuWarna, ListKartu).

shuffle([], []).
shuffle(Awal, [ElemenAcak|SisaAcak]) :-
    getLenght(Awal, Panjang),
    random(0, Panjang, Index),
    getElement(Awal, Index, ElemenAcak),
    deleteElement(Awal, Index, AwalSisa),
    shuffle(AwalSisa, SisaAcak).

bagiKartu([], Deck, Deck).
bagiKartu([Pemain|SisaPemain], Deck, SisaDeck):-
    ambilKartu(KartuPemain, 7, Deck, DeckSementara),
    assertz(kartu_pemain(Pemain, KartuPemain)),
    bagiKartu(SisaPemain, DeckSementara, SisaDeck).

ambilKartu([], 0, Deck, Deck) :- !.
ambilKartu([H|TAmbil], N, [H|TDeck], SisaDeck) :-
    N > 0,
    N1 is N - 1,
    ambilKartu(TAmbil, N1, TDeck, SisaDeck).

initDiscard([kartu(Warna, Jenis)|Sisa], SisaAkhir):-
    Warna \= hitam, !,
    SisaAkhir = Sisa,
    assertz(discard_top(kartu(Warna, Jenis))),
    assertz(warna_aktif(Warna)),
    write('Kartu awal di discard pile: '), write(kartu(Warna, Jenis)), nl.
initDiscard([kartu(Warna, Jenis)|Sisa], SisaAkhir):-
    getLenght(Sisa, Panjang),
    random(0, Panjang, Index),
    insertAt(Sisa, Index, kartu(Warna, Jenis), DeckBaru),
    initDiscard(DeckBaru, SisaAkhir).

printKartu :-
	loadKartu(X), write(X).
