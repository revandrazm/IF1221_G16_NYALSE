:- include('state.pl').
:- include('turn.pl').

aplikasiEfek(skip) :-
    giliranSelanjutnya, !.

aplikasiEfek(reverse) :-
    arahPermainan(ArahAwal),

    (ArahAwal == kanan ->
     ArahBaru = kiri ;
     ArahBaru = kanan),

    retract(arahPermainan(ArahAwal)),
    asserta(arahPermainan(ArahBaru)), !.

aplikasiEfek(drawTwo) :-
    giliranSelanjutnya,
    ambilKartu, !.

aplikasiEfek(wildDrawFour) :-
    giliranSelanjutnya,
    ambilKartu, !.

aplikasiEfek(_) :- !.
