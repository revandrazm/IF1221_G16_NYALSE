/* Daftar Aksi yang Tersedia */
daftarAksiUtama([mainkanKartu(indeksKartu), ambilKartu,
                 tantang, uni(indeksKartu), tangkap(namaPemain)]).

daftarAksiPendukung([lihatCommand, lihatKartu, cekInfo]).

lihatCommand :-
    write('Aksi utama yang tersedia:'), nl,
    printAksiUtama, nl,
    write('Aksi pendukung yang tersedia:'), nl,
    printAksiPendukung, !.

printList([], _).
printList([H|T], N) :-
    format('~w. ~w~n', [N, H]),
    NBerikutnya is N + 1,
    printList(T, NBerikutnya).

printAksiUtama :-
    daftarAksiUtama(DaftarAksi),
    printList(DaftarAksi, 1).

printAksiPendukung :-
    daftarAksiPendukung(DaftarAksi),
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
	format('Nama pemain ~d: ~w', [N, H]), nl,
	kartuPemain(H, DaftarKartu),
	h_ListLength(DaftarKartu, JumlahKartu),
	format('Jumlah kartu: ~d', [JumlahKartu]), nl, nl,
	NBerikutnya is N + 1,
	printUrutan(T, NBerikutnya).

/* Menampilkan Informasi Permainan */
lihatKartu :-
	giliran(Player),
	kartuPemain(Player, DaftarKartu), nl,
	write('Berikut kartu yang anda miliki'), nl,
	lihatKartu(DaftarKartu, 1).

cekInfo :-
	discardTop(KartuTeratas),
	urutanPemain(Urutan),
	write('Kartu discard top: '), h_FormatCard(KartuTeratas), nl, nl,
	write('Urutan pemain: '), formatUrutan(Urutan), nl, nl,
	printUrutan(Urutan, 1).

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
    format('~w: kartu habis = ~w poin~n', [Pemain, Poin]),
    printSkor(Sisa).
printSkor([(Pemain, Poin)|Sisa]) :-
    kartuPemain(Pemain, DaftarKartu),
    format('~w: ', [Pemain]),
    printKartu(DaftarKartu),
    printPoin(DaftarKartu),
    format('~w poin~n', [Poin]),
    printSkor(Sisa).

printPeringkat([], _) :- !.
printPeringkat([(Pemain, Poin)|Sisa], Peringkat) :-
    format('~w. ~w (~w Poin)~n', [Peringkat, Pemain, Poin]),
    PeringkatSelanjutnya is Peringkat + 1,
    printPeringkat(Sisa, PeringkatSelanjutnya).

printUrutanAwal:-
    nl,
    urutanPemain(DaftarPemain),
    write('Urutan pemain: '),
    cetakDaftarUrutanPemain(DaftarPemain),
    nl.

cetakDaftarUrutanPemain([]) :- !.
cetakDaftarUrutanPemain([PemainTerakhir]) :-
    format('~w.', [PemainTerakhir]), 
    !.
cetakDaftarUrutanPemain([PemainAktif|SisaPemain]) :-
    format('~w - ', [PemainAktif]),
    cetakDaftarUrutanPemain(SisaPemain).
