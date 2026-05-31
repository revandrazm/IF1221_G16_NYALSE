giliranSelanjutnya :-
    giliran(PemainSekarang),
    urutanPemain(DaftarPemain),
    arahPermainan(Arah),

    h_ListIndexOf(DaftarPemain, PemainSekarang, IndeksLama),
    h_ListLength(DaftarPemain, JumlahPemain),
    (   Arah == kanan
    ->  IndeksBaru is (IndeksLama + 1) mod JumlahPemain
    ;   IndeksBaru is (IndeksLama - 1 + JumlahPemain) mod JumlahPemain),

    h_ListGetElement(DaftarPemain, IndeksBaru, PemainBerikutnya),

    retract(giliran(PemainSekarang)),
    asserta(giliran(PemainBerikutnya)),

    cls,

    discardTop(KartuMeja),
    warnaAktif(Warna),

    nl,
    write('==========================================='), nl,
    format('          GILIRAN: ~w~n', [PemainBerikutnya]),
    write('-------------------------------------------'), nl,
    write(' [i] Kartu Teratas : '), h_FormatCard(KartuMeja), nl,
    format(' [i] Warna Aktif   : ~w~n', [Warna]),
    write('==========================================='), nl, !.

giliranSebelumnya(Nama) :-
    giliran(PemainSekarang),
    urutanPemain(DaftarPemain),
    arahPermainan(Arah),

    h_ListIndexOf(DaftarPemain, PemainSekarang, Indeks),
    h_ListLength(DaftarPemain, JumlahPemain),
    (   Arah == kanan
    ->  IndeksPemainSebelumnya is ( Indeks - 1 + JumlahPemain) mod JumlahPemain
    ;   IndeksPemainSebelumnya is ( Indeks + 1) mod JumlahPemain),

    h_ListGetElement(DaftarPemain, IndeksPemainSebelumnya, Nama).