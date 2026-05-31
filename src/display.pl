/* Daftar Aksi yang Tersedia */
daftarAksiUtamaKontekstual([pilihWarna(warna)]) :-
    memilihWarna(true), !.

daftarAksiUtamaKontekstual([ambilKartu, tantang]) :-
    discardTop(kartu(hitam, wildDrawFour)), !.

daftarAksiUtamaKontekstual(DaftarAksi) :-
    giliran(Pemain),
    kartuPemain(Pemain, DaftarKartu),
    AksiAwal = [mainkanKartu(indeksKartu), ambilKartu],

    (   h_ListLength(DaftarKartu, 2)
    ->  h_ListAppendList(AksiAwal, [uni(indeksKartu)], AksiAkhir)
    ;   AksiAkhir = AksiAwal
    ),

    h_ListAppendList(AksiAkhir, [tangkap(namaPemain)], DaftarAksi).

daftarAksiPendukung([lihatCommand, lihatKartu, cekInfo]).

lihatCommand :-
    daftarAksiUtamaKontekstual(DaftarUtama),
    daftarAksiPendukung(DaftarPendukung),
    nl, write('================[ DAFTAR PERINTAH ]================'), nl,
    write(' [i] Aksi Utama (Mengakhiri Giliran):'), nl,
    printList(DaftarUtama, 1), nl,
    write(' [i] Aksi Pendukung:'), nl,
    printList(DaftarPendukung, 1),
    write('==================================================='), nl, !.

printList([], _).
printList([H|T], N) :-
    format('     ~w. ~w~n', [N, H]),
    NBerikutnya is N + 1,
    printList(T, NBerikutnya).

printAksiUtama :-
    daftarAksiUtama(DaftarAksi),
    printList(DaftarAksi, 1).

/* Menampilkan Kartu Tangan Pemain */
lihatKartu([], _) :- !.
lihatKartu([kartu(Warna,Jenis)|Sisa], N) :-
	format('~d. ', [N]),
	h_FormatCard(kartu(Warna, Jenis)), nl,
	NBerikutnya is N+1,
	lihatKartu(Sisa, NBerikutnya).

/* Format Urutan Pemain */
formatUrutanSisa([]) :- !.
formatUrutanSisa([H|T]) :-
	write(' - '), write(H),
	formatUrutanSisa(T).

formatUrutan([H|T]):-
	write(H),
	formatUrutanSisa(T).

printUrutan([], _) :- !.
printUrutan([H|T], N):-
	format(' [i] Nama pemain ~d: ~w', [N, H]), nl,
	kartuPemain(H, DaftarKartu),
	h_ListLength(DaftarKartu, JumlahKartu),
	format('     Jumlah kartu: ~d', [JumlahKartu]), nl,
	( T \= [] -> nl ; true ),
	NBerikutnya is N + 1,
	printUrutan(T, NBerikutnya).

/* Menampilkan Informasi Permainan */
lihatKartu :-
	giliran(Player),
	kartuPemain(Player, DaftarKartu), nl,
	write('================[ KARTU ANDA ]================'), nl,
	lihatKartu(DaftarKartu, 1),
    write('=============================================='), nl.

cekInfo :-
	discardTop(KartuTeratas),
	urutanPemain(Urutan),
    warnaAktif(WarnaAktif),
    arahPermainan(Arah),
    giliran(PemainAktif),
    nl,
    write('================[ STATUS GAME ]================'), nl,
	format(' [i] Kartu Teratas  : ', []), h_FormatCard(KartuTeratas), nl,
    format(' [i] Warna Aktif    : ~w~n', [WarnaAktif]),
    format(' [i] Arah Permainan : ~w~n', [Arah]),
    format(' [i] Giliran Saat Ini: ~w~n', [PemainAktif]),
    write('-----------------------------------------------'), nl,
	write(' [i] Daftar Pemain & Jumlah Kartu:'), nl,
	printUrutan(Urutan, 1),
    write('==============================================='), nl.

/* Menampilkan Kartu dalam Format Penjumlahan */
printKartu([Kartu]) :-
    h_FormatCard(Kartu),
    write(' = ').
printKartu([Kartu|Sisa]) :-
    h_ListLength(Sisa, Panjang),
    Panjang > 0, !,
    h_FormatCard(Kartu),
    write(' + '),
    printKartu(Sisa).

printPoin([kartu(_, Jenis)]) :-
    nilaiKartu(Jenis, Poin),
    format('~w = ', [Poin]).
printPoin([kartu(_, Jenis)|Sisa]) :-
    h_ListLength(Sisa, Panjang),
    Panjang > 0, !,
    nilaiKartu(Jenis, Poin),
    format('~w + ', [Poin]),
    printPoin(Sisa).

printSkor([]) :- !.
printSkor([(Pemain, Poin)|Sisa]) :-
    kartuPemain(Pemain, []), !,
    format(' - ~w: kartu habis = ~w poin~n', [Pemain, Poin]),
    printSkor(Sisa).
printSkor([(Pemain, Poin)|Sisa]) :-
    kartuPemain(Pemain, DaftarKartu),
    format(' - ~w: ', [Pemain]),
    printKartu(DaftarKartu),
    printPoin(DaftarKartu),
    format('~w poin~n', [Poin]),
    printSkor(Sisa).

printPeringkat([], _) :- !.
printPeringkat([(Pemain, Poin)|Sisa], Peringkat) :-
    format('   ~w. ~w (~w Poin)~n', [Peringkat, Pemain, Poin]),
    PeringkatSelanjutnya is Peringkat + 1,
    printPeringkat(Sisa, PeringkatSelanjutnya).

printUrutanAwal:-
    nl,
    urutanPemain(DaftarPemain),
    write('[i] Urutan pemain: '),
    cetakDaftarUrutanPemain(DaftarPemain),
    nl.

cetakDaftarUrutanPemain([]) :- !.
cetakDaftarUrutanPemain([PemainTerakhir]) :-
    format('~w.', [PemainTerakhir]),
    !.
cetakDaftarUrutanPemain([PemainAktif|SisaPemain]) :-
    format('~w - ', [PemainAktif]),
    cetakDaftarUrutanPemain(SisaPemain).
