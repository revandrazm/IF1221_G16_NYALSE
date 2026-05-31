aplikasiEfek(skip) :-
    giliranSelanjutnya,
    giliran(Korban),
    format('[!] EFEK SKIP: ~w terlewati dan kehilangan giliran!~n', [Korban]),
    giliranSelanjutnya, !.

aplikasiEfek(reverse) :-
    arahPermainan(ArahAwal),

    (   ArahAwal == kanan 
    ->  ArahBaru = kiri 
    ;   ArahBaru = kanan
    ),

    retract(arahPermainan(ArahAwal)),
    asserta(arahPermainan(ArahBaru)),

    format('[!] EFEK REVERSE: Arah permainan dibalik menjadi ke ~w!~n', [ArahBaru]),
    giliranSelanjutnya, !.

aplikasiEfek(drawTwo) :-
    giliranSelanjutnya,
    giliran(Korban),
    tarikKartu(Korban, 2),
    format('[!] EFEK +2: ~w terpaksa mengambil 2 kartu dan kehilangan giliran!~n', [Korban]),
    giliranSelanjutnya, !. 

aplikasiEfek(wild) :-
    write('[?] EFEK WILD: Pilih warna baru (gunakan pilihWarna(Warna))'), nl,
    retract(memilihWarna(false)),
    asserta(memilihWarna(true)), !.

aplikasiEfek(wildDrawFour) :-
    write('[?] EFEK +4: Pilih warna baru (gunakan pilihWarna(Warna))'), nl,
    format('[!] Hati-hati! Pemain berikutnya terancam mengambil 4 kartu jika tidak menantang.~n', []),
    retract(memilihWarna(false)),
    asserta(memilihWarna(true)), !.

aplikasiEfek(_) :-
    giliranSelanjutnya, !.

pilihWarna(Warna) :-
    memilihWarna(true), !,
    (   cekWarnaValid(Warna)
    ->  retractall(memilihWarna(true)),
        asserta(memilihWarna(false)),

        retractall(warnaAktif(_)),
        asserta(warnaAktif(Warna)),

        format('[i] Berhasil! Warna permainan sekarang menjadi ~w.~n', [Warna]), nl,
        discardTop(kartu(_, Jenis)),
        ( Jenis == wildDrawFour -> retractall(ancamanHukuman(_)), asserta(ancamanHukuman(true)) ; true ),
        giliranSelanjutnya
    ;   write('[!] Warna tidak valid! Silakan pilih: merah, kuning, hijau, atau biru.'), nl
    ).

pilihWarna(_) :-
    write('[!] Anda tidak sedang dalam fase memilih warna!'), nl.
