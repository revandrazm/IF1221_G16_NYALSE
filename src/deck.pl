:- include('facts.pl').
:- include('utils.pl').

kombinasiSatuWarna(_, [], []).
kombinasiSatuWarna(Warna, [Jenis|SisaJenis], [kartu(Warna, Jenis)|BagianHasil]) :-
    kombinasiSatuWarna(Warna, SisaJenis, BagianHasil).

kombinasiSemuaWarna([], _, []).
kombinasiSemuaWarna([Warna|SisaWarna], Jenis, HasilAkhir) :-
    kombinasiSatuWarna(Warna, Jenis, HasilSatuWarna),
    kombinasiSemuaWarna(SisaWarna, Jenis, HasilSementara),
    h_ListAppendList(HasilSementara, HasilSatuWarna, HasilAkhir).

% Convert fakta kartu ke list
loadKartu(ListKartu):-
    warnaDasar(ListWarna),
    jenisKartu(ListJenis),
    kartuHitam(ListKartuHitam),
    kombinasiSemuaWarna(ListWarna, ListJenis, ListKartuWarna),
    h_ListAppendList(ListKartuHitam, ListKartuWarna, ListKartu).

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
    h_ListLength(Sisa, Panjang),
    random(0, Panjang, Index),
    h_ListInsertAtIndex(Sisa, Index, kartu(Warna, Jenis), DeckBaru),
    initDiscard(DeckBaru, SisaAkhir).

printKartu :-
	loadKartu(X), write(X).
