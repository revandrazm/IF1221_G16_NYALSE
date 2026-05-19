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
nilaiKartu(drawTwo, 10).
nilaiKartu(wild, 20).
nilaiKartu(wildDrawFour, 20).

/* Validitas Kartu */
kartuMainValid(kartu(Warna, Jenis)) :-
    discardTop(kartu(WarnaDiscard, JenisDiscard)),
    ( (Warna = WarnaDiscard,Warna \= hitam)
    ; (Jenis = JenisDiscard,Jenis \= wild)
    ; (Jenis = wild,JenisDiscard \= wild)
    ; Jenis = wildDrawFour
    ).

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
loadKartu(DaftarKartu):-
    warnaDasar(DaftarWarna),
    jenisKartu(DaftarJenis),
    kartuHitam(DaftarKartuHitam),
    kombinasiSemuaWarna(DaftarWarna, DaftarJenis, DaftarKartuWarna),
    h_ListAppendList(DaftarKartuHitam, DaftarKartuWarna, DaftarKartu).

initDiscard([kartu(Warna, Jenis)|Sisa], SisaAkhir):-
    Warna \= hitam, !,
    SisaAkhir = Sisa,
    assertz(discardTop(kartu(Warna, Jenis))),
    assertz(warnaAktif(Warna)),
    write('Kartu awal di discard pile: '), write(kartu(Warna, Jenis)), nl.
initDiscard([kartu(Warna, Jenis)|Sisa], SisaAkhir):-
    h_ListLength(Sisa, Panjang),
    random(0, Panjang, Indeks),
    h_ListInsertAtIndex(Sisa, Indeks, kartu(Warna, Jenis), DeckBaru),
    initDiscard(DeckBaru, SisaAkhir).