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
    format('[!] EFEK +2: ~w terpaksa mengambil 2 kartu dan kehilangan giliran!~n', [Korban]),
    tarikKartu(Korban, 2),
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

/* Bonus Mimic */
aplikasiEfek(mimic) :-
    ( aksiTerakhir(kartu(WarnaAksi, JenisAksi))
    		->
        format('[i] Kartu aksi terakhir yang dimainkan: ~w-~w~n', [WarnaAksi, JenisAksi]),
        format('[i] Kartu mimic menyalin efek ~w!~n', [JenisAksi]),
        retractall(efekMimic(_)),
        asserta(efekMimic(JenisAksi))
        ;
        write('[i] Belum ada kartu aksi sebelumnya.'), nl,
        write('[i] Kartu mimic berfungsi sebagai wild biasa.'), nl,
        retractall(efekMimic(_)),
        asserta(efekMimic(wild))
    ),
    write('[?] Pilih warna baru (gunakan pilihWarna(Warna))'), nl,
    retractall(memilihWarna(_)),
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
        (
        	Jenis == wildDrawFour -> retractall(ancamanHukuman(_)), asserta(ancamanHukuman(true)), giliranSelanjutnya
        ;
        	Jenis == mimic ->
         	(		efekMimic(EfekMimic)
          ->	retractall(efekMimic(_)),
	            (
								EfekMimic == skip -> aplikasiEfek(skip)
	            ;
	            	EfekMimic == reverse -> aplikasiEfek(reverse)
	            ;
	            	EfekMimic == drawTwo -> aplikasiEfek(drawTwo)
	            ;
	            	EfekMimic == wildDrawFour -> retractall(ancamanHukuman(_)), asserta(ancamanHukuman(true)), giliranSelanjutnya
	            ;
	            	giliranSelanjutnya
						  )
					;
						giliranSelanjutnya
          )
        ;
        	giliranSelanjutnya
        )
    ;   write('[!] Warna tidak valid! Silakan pilih: merah, kuning, hijau, atau biru.'), nl
    ).

pilihWarna(_) :-
    write('[!] Anda tidak sedang dalam fase memilih warna!'), nl.
