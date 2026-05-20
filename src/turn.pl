:- include('player.pl').

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

    format('~nGiliran ~w.', [PemainBerikutnya]), !.
