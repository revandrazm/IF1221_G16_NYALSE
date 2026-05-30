:- include('state.pl').
:- include('turn.pl').
:- include('rule.pl').

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

aplikasiEfek(wild) :-
    write('Pilih warna (gunakan pilihWarna(Warna)): '),
    retract(memilihWarna(false)),
    asserta(memilihWarna(true)).

pilihWarna(Warna) :-
    memilihWarna(true), !,
    (   cekWarnaValid(Warna)
    ->  retract(memilihWarna(true)),
        asserta(memilihWarna(false)),

        retract(warnaAktif(_)),
        asserta(warnaAktif(Warna)),

        format('Berhasil! Warna permainan sekarang menjadi ~w.~n', [Warna]),
    ;   write('Warna tidak valid! Silakan pilih: merah, kuning, hijau, atau biru.'), nl,
        fail
    ).

pilihWarna(_) :-
    write('Anda tidak sedang dalam fase memilih warna!'), nl.

aplikasiEfek(wildDrawFour) :-
    giliranSelanjutnya,
    ambilKartu, !.

aplikasiEfek(_) :- !.
