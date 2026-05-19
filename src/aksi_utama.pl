:- include('facts.pl').
:- include('utils.pl').
:- include('deck.pl').

mainkanKartu(Idx) :-
    giliran(Pemain), urutanPemain(Urutan), h_ListIndexOf(Urutan, Pemain, IdPemain), h_ListLength(Urutan, NPemain), kartuPemain(Pemain, Deck), h_ListLength(Deck, N),
    0 =< Idx, Idx < N,
    h_ListAtIndex(Deck, Idx, Kartu),
    % kartuMainValid(Kartu),
    h_ListRemoveAtIndex(Deck, Idx, Deck2),
    retract(kartuPemain(Pemain,_)), asserta(kartuPemain(Pemain,Deck2)),
    format('~w memainkan kartu: ~w', [Pemain,Kartu]), /*formatCard(Kartu),*/ write('.'), nl,

    giliranSelanjutnya.

kartuMainValid(kartu(Warna, Jenis)) :-
    discardTop(kartu(Warna2,Jenis2)),
    Warna=Warna2, Jenis=Jenis2.

ambilKartu :-
    giliran(Pemain),
    kartu_pemain(Pemain, KartuSebelum),
    discard_top(kartu(W, J)),

    (J == drawTwo -> Jumlah = 2 ;
     J == drawFour -> Jumlah = 4 ;
     Jumlah = 1),

    ambilSejumlahKartu(Jumlah, KartuBaru),
    h_ListAppendList(KartuSebelum, KartuBaru, KartuSesudah),

    retract(kartu_pemain(Pemain, KartuSebelum)),
    asserta(kartu_pemain(Pemain, KartuSesudah)),

    format('Kartu ~w telah diperbarui. Kartu sekarang: ~w~n', [Pemain, KartuSesudah]).

ambilSejumlahKartu(Jumlah, ListKartuTerpilih) :-
    deck(DekAwal),
    prosesAmbil(Jumlah, DekAwal, DekSisa, ListKartuTerpilih),
    retract(deck(DekAwal)),
    asserta(deck(DekSisa)).

prosesAmbil(0, Dek, Dek, []) :- !.
prosesAmbil(Jumlah, Dek, DekAkhir, [Kartu|Sisa]) :-
    h_ListLength(Dek, Length),
    random(0, Length, IndeksPilih),
    h_ListGetElement(Dek, IndeksPilih, Kartu),
    h_ListRemoveAtIndex(Dek, IndeksPilih, DekSisa),
    JumlahBaru is Jumlah - 1,
    prosesAmbil(JumlahBaru, DekSisa, DekAkhir, Sisa).

giliranSelanjutnya :-
    giliran(PemainSekarang),
    urutan_pemain(DaftarPemain),
    arah_permainan(Arah),

    h_ListIndexOf(DaftarPemain, PemainSekarang, IndexLama),
    h_ListLength(DaftarPemain, JumlahPemain),
    (Arah == kanan ->
     IndexBaru is (IndexLama + 1) mod JumlahPemain ;
     IndexBaru is (IndexLama - 1 + JumlahPemain) mod JumlahPemain),

    h_ListGetElement(DaftarPemain, IndexBaru, PemainBerikutnya),

    retract(giliran(PemainSekarang)),
    asserta(giliran(PemainBerikutnya)),

    format('Giliran ~w.', [PemainBerikutnya]).
