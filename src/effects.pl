hukumAmbilKartu(Pemain, Jumlah) :-
    kartuPemain(Pemain, DaftarKartuLama),
    ambilSejumlahKartu(Jumlah, KartuBaru),
    h_ListAppendList(DaftarKartuLama, KartuBaru, DaftarKartuBaru),
    retract(kartuPemain(Pemain, DaftarKartuLama)),
    asserta(kartuPemain(Pemain, DaftarKartuBaru)),
    hapusStatusUni(Pemain),
    format('~w mendapat ~w kartu hukuman.~n', [Pemain, DaftarKartuBaru]).

aplikasiEfek(skip) :-
    giliranSelanjutnya,
    giliran(Korban),
    format('~w kehilangan giliran~n', [Korban]),
    giliranSelanjutnya, !.

aplikasiEfek(reverse) :-
    arahPermainan(ArahAwal),

    (   ArahAwal == kanan 
    ->  ArahBaru = kiri 
    ;   ArahBaru = kanan
    ),

    retract(arahPermainan(ArahAwal)),
    asserta(arahPermainan(ArahBaru)),

    format('Arah permainan dibalik menjadi ke arah ~w!~n', [ArahBaru]),
    giliranSelanjutnya, !.

aplikasiEfek(drawTwo) :-
    giliranSelanjutnya,
    giliran(Korban),
    hukumAmbilKartu(Korban, 2),
    giliranSelanjutnya, !. 

aplikasiEfek(wild) :-
    write('Pilih warna (gunakan pilihWarna(Warna))'),
    retract(memilihWarna(false)),
    asserta(memilihWarna(true)).

aplikasiEfek(wildDrawFour) :-
    giliranSelanjutnya,
    ambilKartu,
    giliranSelanjutnya, !.

aplikasiEfek(_) :-
    giliranSelanjutnya, !.

pilihWarna(Warna) :-
    memilihWarna(true), !,
    (   cekWarnaValid(Warna)
    ->  retract(memilihWarna(true)),
        asserta(memilihWarna(false)),

        retract(warnaAktif(_)),
        asserta(warnaAktif(Warna)),

        format('Berhasil! Warna permainan sekarang menjadi ~w.~n', [Warna]), nl,
        giliranSelanjutnya
    ;   write('Warna tidak valid! Silakan pilih: merah, kuning, hijau, atau biru.'), nl
    ).

pilihWarna(_) :-
    write('Anda tidak sedang dalam fase memilih warna!'), nl.
