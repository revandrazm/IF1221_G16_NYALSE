/* God's Hand */
godsHand :-
	random(0,101,Peluang),
	(	Peluang =< 15
		->
		tanganTuhan
		;
		write('[i] Tuhan tidak berkehendak.'), nl,
		giliranSelanjutnya
	).

tanganTuhan :-
	urutanPemain(ListPemain),
	cariKorban(ListPemain, ListKorban),
	(	ListKorban \= []
		->
		h_ListGetRandomElement(ListKorban, Korban),
		cariPenerima(ListPemain, Korban, Penerima),
		pindahkanKartu(Korban, Penerima, KartuPindah),

    write('[i] Tuhan telah berkehendak.'), nl,
    write('[i] Kartu '), h_FormatCard(KartuPindah),
    format(' milik ~w telah berpindah ke tangan ~w!~n', [Korban, Penerima])
		;
		write('[i] Tuhan tidak berkehendak.'), nl
	),
	giliranSelanjutnya. % not sure

cariKorban([], []) :- !.
cariKorban([Pemain|Sisa], ListKorban) :-
	h_JumlahKartuPemain(Pemain, JumlahKartu),
	cariKorban(Sisa, KorbanSementara),

	( JumlahKartu > 1
		->
		ListKorban = [Pemain|KorbanSementara]
		;
		ListKorban = KorbanSementara
	).

cariPenerima(ListPemain, Korban, Penerima) :-
	h_ListGetRandomElement(ListPemain, KandidatPenerima),
	(	KandidatPenerima \= Korban
		->
		Penerima = KandidatPenerima
		;
		cariPenerima(ListPemain, Korban, Penerima)
	).

pindahkanKartu(Korban, Penerima, KartuPindah) :-
	kartuPemain(Korban, KartuKorban),
	kartuPemain(Penerima, KartuPenerima),

	h_ListGetRandomElement(KartuKorban, KartuPindah),
	h_ListIndexOf(KartuKorban, KartuPindah, IndeksPindah),
	h_ListRemoveAtIndex(KartuKorban, IndeksPindah, KartuKorbanBaru),
	retract(kartuPemain(Korban, _)),
	asserta(kartuPemain(Korban, KartuKorbanBaru)),
	h_ListLength(KartuKorbanBaru, JumlahKartuKorban),
	( JumlahKartuKorban == 1 -> tambahStatusUni(Korban); true),

	h_ListAppendElement(KartuPenerima, KartuPindah, KartuPenerimaBaru),
	retract(kartuPemain(Penerima, _)),
	asserta(kartuPemain(Penerima, KartuPenerimaBaru)),
	hapusStatusUni(Penerima).

/* Mimic */
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
