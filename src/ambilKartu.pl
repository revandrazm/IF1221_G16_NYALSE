:- include('facts.pl').
:- include('deck.pl').

ambilKartu :-
    giliran(Pemain),
    kartu_pemain(Pemain, KartuSebelum),
    discard_top(Kartu(W, J)),

    (J == drawTwo -> Jumlah = 2 ;
     J == drawFour -> Jumlah = 4 ;
     Jumlah = 1),

    ambilSejumlahKartu(Jumlah, KartuBaru),
    append(KartuSebelum, KartuBaru, KartuSesudah),

    retract(kartu_pemain(Pemain, KartuSebelum)),
    asserta(kartu_pemain(Pemain, KartuSesudah)),

    giliranSelanjutnya.

ambilSejumlahKartu(0, []) :- !.
ambilSejumlahKartu(Jumlah, [Kartu|Sisa]) :-
    loadKartu(DekKartu),
    random(0, 54, IndeksPilih),
    nth0(IndeksPilih, DekKartu, Kartu),
    JumlahBaru is Jumlah - 1,
    ambilSejumlahKartu(JumlahBaru, Sisa).
