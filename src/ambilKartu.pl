:- include('facts.pl').
:- include('deck.pl').
:- include('helper.pl').

ambilKartu :-
    giliran(Pemain),
    kartu_pemain(Pemain, KartuSebelum),
    discard_top(kartu(W, J)),

    (J == drawTwo -> Jumlah = 2 ;
     J == drawFour -> Jumlah = 4 ;
     Jumlah = 1),

    ambilSejumlahKartu(Jumlah, KartuBaru),
    appendHelper(KartuSebelum, KartuBaru, KartuSesudah),

    retract(kartu_pemain(Pemain, KartuSebelum)),
    asserta(kartu_pemain(Pemain, KartuSesudah)),

    format('Kartu ~w telah diperbarui. Kartu sekarang: ~w~n', [Pemain, KartuSesudah]),

    giliranSelanjutnya.

ambilSejumlahKartu(0, []) :- !.
ambilSejumlahKartu(Jumlah, [Kartu|Sisa]) :-
    loadKartu(DekKartu),
    random(0, 54, IndeksPilih),
    nth0Helper(IndeksPilih, DekKartu, Kartu),
    JumlahBaru is Jumlah - 1,
    ambilSejumlahKartu(JumlahBaru, Sisa).

giliranSelanjutnya :-
    giliran(PemainSekarang),
    urutan_pemain(DaftarPemain),

    nth0Helper(IndexLama, DaftarPemain, PemainSekarang),
    lengthHelper(DaftarPemain, JumlahPemain),
    IndexBaru is (IndexLama + 1),

    nth0Helper(IndexBaru, DaftarPemain, PemainBerikutnya),

    retract(giliran(PemainSekarang)),
    asserta(giliran(PemainBerikutnya)).
