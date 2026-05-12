:- include('facts.pl').
:- include('deck.pl').
:- include('player.pl').
:- dynamic(gameRunning/1).
:- initialization(main).

main :- startGame.

startGame :-
    assertz(gameRunning(true)),

    write('*******************************************'), nl,
    write('*         SELAMAT DATANG DI UNI!          *'), nl,
    write('*******************************************'), nl,  

    inputJumlahPemain(N),
    inisialisasiPemain(N, ListPemain),
    loadKartu(Deck),
    shuffle(Deck, DeckAcak),
    bagiKartu(ListPemain, DeckAcak, SisaDeck),
    initDiscard(SisaDeck, SisaDeckAkhir),
    
    assertz(deck(SisaDeckAkhir)),
    assertz(arah_permainan(kanan)),

    write('Set up selesai! Permainan dimulai!'), nl.

inputJumlahPemain(N):-
    write('Masukkan jumlah pemain (2-4, akhiri dengan titik): '),
    read(Input),
    ( integer(Input), Input >= 2, Input =< 4 -> N = Input
    ;
        write('Jumlah pemain tidak valid! Masukkan jumlah pemain lagi.'), nl,
        inputJumlahPemain(N)
    ).