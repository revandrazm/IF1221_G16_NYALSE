startGame :-
    setupOS,
    cls,
    retractall(deck(_)),
    retractall(arahPermainan(_)),
    retractall(uniStatus(_)),
    retractall(kartuPemain(_, _)),
    retractall(giliran(_)),
    retractall(urutanPemain(_)),
    retractall(discardTop(_)),
    retractall(warnaAktif(_)),
    retractall(memilihWarna(_)),
    retractall(ancamanHukuman(_)),
    retractall(aksiTerakhir(_)),
    retractall(efekMimic(_)),

    assertz(memilihWarna(false)),

    randomize,

    nl,
    write('.============================================. '), nl,
    write('|                                            |'), nl,
    write('|          __   __  ___    _  _____          |'), nl,
    write('|         |  | |  ||   \\  | ||_   _|         |'), nl,
    write('|         |  | |  || |\\ \\ | |  | |           |'), nl,
    write('|         |  |_|  || | \\ \\| | _| |_          |'), nl,
    write('|          \\_____/ |_|  \\___||_____|         |'), nl,
    write('|                                            |'), nl,
    write('|  ----------------------------------------  |'), nl,
    write('|         SELAMAT DATANG DI PERMAINAN        |'), nl,
    write('|      G-16  N Y A L S E  E D I T I O N      |'), nl,
    write('|  ----------------------------------------  |'), nl,
    write('|                                            |'), nl,
    write('\'============================================\' '), nl,
    nl,

    inputJumlahPemain(JumlahPemain),
    inisialisasiPemain(JumlahPemain, DaftarPemain),
    printUrutanAwal,
    loadKartu(Deck),
    h_Shuffle(Deck, DeckAcak),
    nl, write('[i] Setiap pemain mendapat 7 kartu acak.'), nl,
    bagiKartu(DaftarPemain, DeckAcak, SisaDeck),
    initDiscard(SisaDeck, SisaDeckAkhir),

    assertz(deck(SisaDeckAkhir)),
    assertz(arahPermainan(kanan)),
    assertz(uniStatus([])),

    giliran(PemainAktif),
    nl, write('[i] Set up selesai! Permainan dimulai!'), nl,
    cls,
    discardTop(KartuMeja),
    warnaAktif(Warna),
    nl,
    write('==========================================='), nl,
    format('          GILIRAN: ~w~n', [PemainAktif]),
    write('-------------------------------------------'), nl,
    write(' [i] Kartu Teratas : '), h_FormatCard(KartuMeja), nl,
    format(' [i] Warna Aktif   : ~w~n', [Warna]),
    write('==========================================='), nl,

    gameLoop.

setupOS :-
    osSistem(_), !.
setupOS :-
    write('[?] Apakah Anda menggunakan OS Windows? (y/n, akhiri dengan titik): '),
    read(Jawaban),
    (   Jawaban == y
    ->  assertz(osSistem(windows))
    ;   assertz(osSistem(unix))
    ).

inputJumlahPemain(N):-
    repeat,
    write('[?] Masukkan jumlah pemain (2-4, akhiri dengan titik): '),
    read(Input),
    (   integer(Input), Input >= 2, Input =< 4
    ->  N = Input, nl, !
    ;   write('[!] Jumlah pemain tidak valid! Masukkan jumlah pemain lagi.'), nl,
        fail
    ).

gameLoop :-
    cekGameOver(_), !,
    endGame.

gameLoop :-
    giliran(PemainAktif),
    playerTurnLoop(PemainAktif),
    gameLoop.

playerTurnLoop(Pemain) :-
    nl, write('[?] Masukkan perintah: '),
    read(Perintah),
    (   memilihWarna(true), \+ (Perintah = pilihWarna(_); Perintah = lihatCommand; Perintah = cekInfo; Perintah = lihatKartu)
    ->  write('[!] Anda harus memilih warna! Gunakan pilihWarna(Warna).'), nl,
        playerTurnLoop(Pemain)

    ;   ancamanHukuman(true), \+ (Perintah = tantang; Perintah = ambilKartu; Perintah = lihatCommand; Perintah = cekInfo; Perintah = lihatKartu)
    ->  write('[!] Anda terkena efek Wild Draw Four! Anda HANYA boleh memilih ambilKartu atau tantang.'), nl,
        playerTurnLoop(Pemain)

    ;   jalankanPerintah(Perintah, Pemain)
    ).

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
    ;   write('[!] Gagal mengambil kartu.'), nl,
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
jalankanPerintah(godsHand, Pemain) :-
    !,
    (   godsHand
    ->  true
    ;   playerTurnLoop(Pemain)
    ).

jalankanPerintah(tangkap(Target), Pemain) :-
    !,
    (   tangkap(Target)
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

jalankanPerintah(saveGame, Pemain) :-
    !,
    saveGame,
    playerTurnLoop(Pemain).

jalankanPerintah(loadGame, _) :-
    !,
    loadGame,
    giliran(PemainAktif),
    cls,
    discardTop(KartuMeja),
    warnaAktif(Warna),
    nl,
    write('==========================================='), nl,
    format('          GILIRAN: ~w~n', [PemainAktif]),
    write('-------------------------------------------'), nl,
    write(' [i] Kartu Teratas : '), h_FormatCard(KartuMeja), nl,
    format(' [i] Warna Aktif   : ~w~n', [Warna]),
    write('==========================================='), nl, !.

jalankanPerintah(_, Pemain) :-
    write('[!] Perintah tidak dikenali atau format salah.'), nl,
    write('[i] Ketik lihatCommand untuk melihat perintah yang tersedia.'), nl,
    playerTurnLoop(Pemain).
