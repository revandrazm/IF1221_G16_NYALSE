:- include('facts.pl').

ambilKartu :-
    giliranSekarang(Pemain),
    efekTerakhir(Efek),

    (Efek == drawTwo -> Jumlah = 2 ;
     Efek == drawFour -> Jumlah = 4 ;
     Jumlah = 1),

    ambilSejumlahKartu(Jumlah, KartuBaru),
    tambahKeTangan(Pemain, KartuBaru),

    retract(efekTerakhir(Efek)),
    asserta(efekTerakhir(none)),

    giliranSelanjutnya.

ambilSejumlahKartu(0, []) :- !.
ambilSejumlahKartu(Jumlah, [Kartu|Sisa]) :-
    loadKartu(DekKartu)
    pickRandom(Kartu, DekKartu),
    NBaru is N - 1,
    ambilSejumlahKartu(NBaru, Sisa).
