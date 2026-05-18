:- include('utils.pl').

inisialisasiPemain(N, ListPemain) :-
    inputNama(N, [], ListPemainUtuh),
    h_Shuffle(ListPemainUtuh, ListPemainAcak),
    ListPemain = ListPemainAcak,
    assertz(urutan_pemain(ListPemain)),
    [FirstPlayer|_] = ListPemain,
    assertz(giliran(FirstPlayer)).

inputNama(0, Acc, Acc) :- !.
inputNama(N, Acc, Result) :-
    N > 0,
    write('Masukkan nama pemain (akhiri dengan titik): '),
    read(Nama),
    (h_ListIsMember(Nama, Acc) ->
        write('Nama sudah digunakan, gunakan nama lain!'), nl,
        inputNama(N, Acc, Result)
    ;
        N1 is N - 1,
        append(Acc, [Nama], NextAcc),
        inputNama(N1, NextAcc, Result)
    ).