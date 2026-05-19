:- include('state.pl').
:- include('player.pl').

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

    format('~nGiliran ~w.', [PemainBerikutnya]), !.
