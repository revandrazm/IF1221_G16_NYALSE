:- include('facts.pl').
:- include('deck.pl').
:- include('player.pl').
startGame :-
    write('*******************************************'), nl,
    write('*         SELAMAT DATANG DI UNI!          *'), nl,
    write('*******************************************'), nl,  

    inputJumlahPemain(N),
    inisialisasiPemain(N, ListPemain).

inputJumlahPemain(N):-
    write('Masukkan jumlah pemain (2-4, akhiri dengan titik): '),
    read(Input),
    ( integer(Input), Input >= 2, Input =< 4 -> N = Input
    ;
        write('Jumlah pemain tidak valid! Masukkan jumlah pemain lagi.')
        inputJumlahPemain(N)
    ).
