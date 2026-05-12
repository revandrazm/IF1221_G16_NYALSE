:- include('facts.pl').
:- include('deck.pl').

ambilKartu :-
    giliran(Pemain),
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
    random(0, 54, IndeksPilih),
    nth0(IndeksPilih, DekKartu, Kartu),
    JumlahBaru is Jumlah - 1,
    ambilSejumlahKartu(JumlahBaru, Sisa).
