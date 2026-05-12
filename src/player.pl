inisialisasiPemain(N, ListPemain) :-
    inputNama(N, [], ListPemainUtuh),
    ListPemain = ListPemainUtuh.

inputNama(0, Acc, Acc) :- !.
inputNama(N, Acc, Result) :-
    N > 0,
    write('Masukkan nama pemain (akhiri dengan titik): '),
    read(Nama),
    (member(Nama, Acc) ->
        write('Nama sudah digunakan, gunakan nama lain!'),
        inputNama(N, Acc, Result)
    ;
        N1 is N - 1,
        append(Acc, [Nama], NextAcc),
        inputNama(N1, NextAcc, Result)
    ).