:- include('state.pl').
:- include('utils.pl').
:- include('turn.pl').
:- include('action.pl').

aplikasiEfek(skip) :-
    giliranSelanjutnya,
    giliranSelanjutnya, !.

aplikasiEfek(reverse) :-
    arah_permainan(ArahAwal),

    (ArahAwal == kanan ->
     ArahBaru = kiri ;
     ArahBaru = kanan),

    retract(arah_permainan(ArahAwal)),
    asserta(arah_permainan(ArahBaru)),

    giliranSelanjutnya, !.

aplikasiEfek(drawTwo) :-
    giliranSelanjutnya,
    ambilKartu,
    giliranSelanjutnya, !.

aplikasiEfek(wildDrawFour) :-
    giliranSelanjutnya,
    ambilKartu,
    giliranSelanjutnya, !.

aplikasiEfek(_):
    giliranSelanjutnya.
