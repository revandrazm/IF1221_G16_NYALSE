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
    loadKartu(DekKartu),
    IndeksPertama is 0,
    IndeksTerakhir is 53 + 1,
    random(IndeksPertama, IndeksTerakhir, IndeksPilih),
    nth0(IndeksPilih, DekKartu, Kartu),
    JumlahBaru is Jumlah - 1,
    ambilSejumlahKartu(JumlahBaru, Sisa).
