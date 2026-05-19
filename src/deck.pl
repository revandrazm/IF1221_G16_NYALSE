:- include('state.pl').
:- include('utils.pl').

/* Daftar Kartu Valid*/
warnaDasar([merah, kuning, hijau, biru]).
jenisKartu([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, skip, reverse, drawTwo]).
kartuHitam([kartu(hitam, wild), kartu(hitam, wildDrawFour)]).
nilaiKartu(0, 0).
nilaiKartu(1, 1).
nilaiKartu(2, 2).
nilaiKartu(3, 3).
nilaiKartu(4, 4).
nilaiKartu(5, 5).
nilaiKartu(6, 6).
nilaiKartu(7, 7).
nilaiKartu(8, 8).
nilaiKartu(9, 9).
nilaiKartu(skip, 10).
nilaiKartu(reverse, 10).
nilaiKartu(draw_two, 10).
nilaiKartu(wild, 20).
nilaiKartu(wild_draw_four, 20).

/* Validitas Kartu */
kartuMainValid(kartu(Warna, Jenis)) :-
    discard_top(kartu(WarnaDiscard, JenisDiscard)),
    ((Warna=WarnaDiscard,Warna\=hitam); (Jenis=JenisDiscard,Jenis\=wild); (Jenis=wild,JenisDiscard\=wild); Jenis=wildDrawFour).

/* Formatting Kartu */
formatKartu(kartu(Warna,Jenis), Atom):-
	format(atom(Atom), '~w-~w', [Warna,Jenis]).

/* Set Up */
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