:- include('state.pl').
:- include('utils.pl').
:- include('deck.pl').
:- include('player.pl').
:- include('turn.pl').
:- include('effects.pl').
:- include('rule.pl').
:- include('display.pl').
:- include('action.pl').
:- include('scoring.pl').

startGame :-
    retractall(gameRunning(_)),
    retractall(deck(_)),
    retractall(arahPermainan(_)),
    retractall(uniStatus(_)),
    retractall(kartuPemain(_, _)),
    retractall(giliran(_)),
    retractall(urutanPemain(_)),
    retractall(discardTop(_)),
    retractall(warnaAktif(_)),
    retractall(memilihWarna(_)),

    assertz(gameRunning(true)),
    assertz(memilihWarna(false)),

    randomize,

    write('*******************************************'), nl,
    write('*         SELAMAT DATANG DI UNI!          *'), nl,
    write('*******************************************'), nl,

    inputJumlahPemain(JumlahPemain),
    inisialisasiPemain(JumlahPemain, DaftarPemain),
    printUrutanAwal,
    loadKartu(Deck),
    h_Shuffle(Deck, DeckAcak),
    nl, write('Setiap pemain mendapat 7 kartu acak.'), nl,
    bagiKartu(DaftarPemain, DeckAcak, SisaDeck),
    initDiscard(SisaDeck, SisaDeckAkhir),

    assertz(deck(SisaDeckAkhir)),
    assertz(arahPermainan(kanan)),
    assertz(uniStatus([])),

    giliran(PemainAktif),
    format('~nGiliran ~w~n', [PemainAktif]),
    nl, write('Set up selesai! Permainan dimulai!'), nl,

    gameLoop.

inputJumlahPemain(N):-
    write('Masukkan jumlah pemain (2-4, akhiri dengan titik): '),
    read(Input),
    (   integer(Input), Input >= 2, Input =< 4
    ->  N = Input
    ;   write('Jumlah pemain tidak valid! Masukkan jumlah pemain lagi.'), nl,
        inputJumlahPemain(N)
    ),
    nl.

gameLoop :-
    cekGameOver(_), !,
    endGame.

gameLoop :-
    giliran(PemainAktif),
    playerTurnLoop(PemainAktif),
    gameLoop.

playerTurnLoop(Pemain) :-
    nl, write('> Masukkan perintah: '),
    read(Perintah),
    jalankanPerintah(Perintah, Pemain).


jalankanPerintah(mainkanKartu(Indeks), Pemain) :-
    !, 
    (   mainkanKartu(Indeks) 
    ->  true 
    ;   playerTurnLoop(Pemain)
    ).

jalankanPerintah(ambilKartu, Pemain) :-
    !,
    ( ambilKartu 
    ->  true 
    ;   write('Gagal mengambil kartu.'), nl, 
        playerTurnLoop(Pemain)
    ).

jalankanPerintah(tantang, Pemain) :-
    !,
    (   tantang 
    ->  true 
    ;   playerTurnLoop(Pemain)
    ).

jalankanPerintah(uni(N), Pemain) :-
    !,
    (   uni(N) 
    ->  true 
    ;   playerTurnLoop(Pemain)
    ).

jalankanPerintah(pilihWarna(Warna), Pemain) :-
    !,
    (   pilihWarna(Warna) 
    ->  true
    ;   playerTurnLoop(Pemain)
    ).

jalankanPerintah(lihatCommand, Pemain) :-
    !, lihatCommand,
    playerTurnLoop(Pemain).

jalankanPerintah(lihatKartu, Pemain) :-
    !, lihatKartu,
    playerTurnLoop(Pemain).

jalankanPerintah(cekInfo, Pemain) :-
    !, cekInfo,
    playerTurnLoop(Pemain).

jalankanPerintah(tangkap(Target), Pemain) :-
    !, tangkap(Target),
    playerTurnLoop(Pemain).

jalankanPerintah(saveGame, sistem) :-
    !,
    write('Fitur saveGame belum diimplementasi.'), nl,
    playerTurnLoop(Pemain).

jalankanPerintah(loadGame, sistem) :-
    !,
    write('Fitur loadGame belum diimplementasi.'), nl,
    playerTurnLoop(Pemain).

jalankanPerintah(_, Pemain) :-
    write('Perintah tidak dikenali atau format salah.'), nl,
    write('Ketik lihatCommand untuk melihat perintah yang tersedia.'), nl,
    playerTurnLoop(Pemain).