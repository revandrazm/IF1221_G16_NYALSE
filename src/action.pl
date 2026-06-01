/* Helper untuk menarik N kartu ke tangan pemain */
tarikKartu(Pemain, Jumlah) :-
    kartuPemain(Pemain, DaftarKartuLama),
    ambilSejumlahKartu(Jumlah, KartuBaru),
    h_ListAppendList(DaftarKartuLama, KartuBaru, DaftarKartuBaru),
    retract(kartuPemain(Pemain, _)),
    asserta(kartuPemain(Pemain, DaftarKartuBaru)),
    hapusStatusUni(Pemain),
    ( giliran(Pemain) ->
        format('    + Rincian kartu: ', []),
        cetakKartuDitarik(KartuBaru)
    ;
        tambahInfoDitarik(Pemain, KartuBaru)
    ).

tambahInfoDitarik(Pemain, KartuBaru) :-
    ( infoKartuDitarik(Pemain, KartuLama) ->
        h_ListAppendList(KartuLama, KartuBaru, Gabungan),
        retract(infoKartuDitarik(Pemain, _)),
        asserta(infoKartuDitarik(Pemain, Gabungan))
    ; asserta(infoKartuDitarik(Pemain, KartuBaru))
    ).

cetakKartuDitarik([]) :- nl.
cetakKartuDitarik([Kartu]) :-
    h_FormatCard(Kartu), nl, !.
cetakKartuDitarik([Kartu|Sisa]) :-
    h_FormatCard(Kartu), write(', '),
    cetakKartuDitarik(Sisa).

mainkanKartu(IndeksMentah) :-
    giliran(Pemain),
    kartuPemain(Pemain, DaftarKartu),
    h_ListLength(DaftarKartu, JumlahKartu),

    Indeks is IndeksMentah - 1,
    (   (Indeks < 0; Indeks >= JumlahKartu)
    ->  write('[!] Indeks kartu di luar jangkauan tanganmu!'), nl,
        fail
    ;
        h_ListAtIndex(DaftarKartu, Indeks, Kartu),
        (   \+ kartuMainValid(Kartu)
        ->  warnaAktif(WarnaAktif), discardTop(kartu(_, JenisDiscard)),
            format('[!] Kartu tidak cocok! (Warna aktif: ~w, Jenis di meja: ~w)~n', [WarnaAktif, JenisDiscard]),
            fail
        ;
            h_ListRemoveAtIndex(DaftarKartu, Indeks, DaftarKartuBaru),
            retract(kartuPemain(Pemain, _)),
            asserta(kartuPemain(Pemain, DaftarKartuBaru)),
            retract(discardTop(_)),
            asserta(discardTop(Kartu)),
            Kartu = kartu(Warna, EfekSetelah),
            h_ListLength(DaftarKartuBaru, SisaKartu),
            (SisaKartu \= 1 -> hapusStatusUni(Pemain) ; true),
            (Warna \= hitam -> retractall(warnaAktif(_)), asserta(warnaAktif(Warna)) ; true),
            format('[>] ~w memainkan kartu: [ ', [Pemain]),
            h_FormatCard(Kartu), write(' ]'), nl,
            ( h_ListIsMember(EfekSetelah, [skip, reverse, drawTwo, wild, wildDrawFour])
            	->
              retractall(aksiTerakhir(_)),
              asserta(aksiTerakhir(Kartu))
              ;
              true
            ),
            aplikasiEfek(EfekSetelah)
        )
    ).

ambilKartu :-
    giliran(Pemain),
    (   ancamanHukuman(true)
    ->  Jumlah = 4,
        retractall(ancamanHukuman(_)),
        asserta(ancamanHukuman(false)),
        format('[i] ~w pasrah dan mengambil 4 kartu hukuman.~n', [Pemain])
    ;   Jumlah = 1,
        format('[i] ~w mengambil 1 kartu dari tumpukan.~n', [Pemain])
    ),
    tarikKartu(Pemain, Jumlah),
    giliranSelanjutnya.

ambilSejumlahKartu(JumlahKartu, DaftarKartuTerpilih) :-
    deck(DeckAwal),
    h_ListLength(DeckAwal, JumlahDeck),
    ( JumlahDeck < JumlahKartu
    -> reshuffleDeck
    ; true
    ),
    deck(DeckBaru),
    prosesAmbil(JumlahKartu, DeckBaru, DeckSisa, DaftarKartuTerpilih),
    retract(deck(_)),
    asserta(deck(DeckSisa)).

prosesAmbil(0, Deck, Deck, []) :- !.
prosesAmbil(JumlahKartu, [KartuTeratas|SisaDeckTersedia], DeckAkhir, [KartuTeratas|SisaAmbilan]) :-
    JumlahKartu > 0,
    JumlahSisa is JumlahKartu - 1,
    prosesAmbil(JumlahSisa, SisaDeckTersedia, DeckAkhir, SisaAmbilan).

reshuffleDeck :-
    write('[i] Kartu deck habis! Sedang mengocok ulang tumpukan kartu'), nl,
    deck(DeckSekarang),
    discardTop(KartuTeratas),

    loadKartu(DeckBaru),

    kumpulkanSemuaKartuPemain(DaftarKartuTangan),
    h_ListAppendElement(DaftarKartuTangan, KartuTeratas, KartuDiluarDeck),

    kurangiDaftarKartu(DeckBaru, KartuDiluarDeck, DeckBaruLengkap),
    h_ListAppendList(DeckBaruLengkap, DeckSekarang, DeckAkhir),

    h_Shuffle(DeckAkhir, DeckAcak),
    retract(deck(_)),
    asserta(deck(DeckAcak)).

kumpulkanSemuaKartuPemain(Hasil) :-
    urutanPemain(DaftarPemain),
    kumpulkanKartuPemain(DaftarPemain, [], Hasil).

kumpulkanKartuPemain([], Akumulasi, Akumulasi).
kumpulkanKartuPemain([Pemain|SisaPemain], Akumulasi, Hasil) :-
    kartuPemain(Pemain, DaftarKartu),
    h_ListAppendList(Akumulasi, DaftarKartu, DaftarKartuAkumulasi),
    kumpulkanKartuPemain(SisaPemain, DaftarKartuAkumulasi, Hasil).

kurangiDaftarKartu(Full, [], Full) :- !.
kurangiDaftarKartu(Full, [H|T], Sisa) :-
    (   h_ListIndexOf(Full, H, Indeks )
    ->  h_ListRemoveAtIndex(Full, Indeks, FullBaru)
    ;   FullBaru = Full
    ),
    kurangiDaftarKartu(FullBaru, T, Sisa).

/* Helpers */
tambahStatusUni(Pemain) :-
	uniStatus(DaftarUni),
	( \+ h_ListIsMember(Pemain, DaftarUni)
    ->  retract(uniStatus(_)),
        asserta(uniStatus([Pemain|DaftarUni]))
  ; true
  ).

hapusStatusUni(Pemain) :-
	uniStatus(DaftarUni),
	( h_ListIsMember(Pemain, DaftarUni)
    ->  h_ListIndexOf(DaftarUni,Pemain,Indeks),
    		h_ListRemoveAtIndex(DaftarUni, Indeks, DaftarUniBaru),
      	retract(uniStatus(_)),
       	asserta(uniStatus(DaftarUniBaru))
	; true
	).

/* Uni Valid */
uni(IndeksMentah):-
	giliran(Pemain),
    kartuPemain(Pemain,DaftarKartu),
	h_ListLength(DaftarKartu, 2),
    Indeks is IndeksMentah - 1,
	h_ListGetElement(DaftarKartu, Indeks, Kartu),
    kartuMainValid(Kartu),
	!,
	h_ListRemoveAtIndex(DaftarKartu, Indeks, DaftarKartuBaru),
	retract(kartuPemain(Pemain, _)),
    asserta(kartuPemain(Pemain, DaftarKartuBaru)),
	retract(discardTop(_)),
    asserta(discardTop(Kartu)),
    Kartu = kartu(Warna, EfekSetelah),
    (Warna \= hitam -> retractall(warnaAktif(_)), asserta(warnaAktif(Warna)) ; true),
	tambahStatusUni(Pemain),
	format('[>] ~w memainkan kartu: [ ',[Pemain]),
    h_FormatCard(Kartu), write(' ]'), nl,
	format('[!] *** ~w MENYERUKAN UNI!!! ***', [Pemain]), nl,
	( h_ListIsMember(EfekSetelah, [skip, reverse, drawTwo, wild, wildDrawFour])
	 	->
	  retractall(aksiTerakhir(_)),
	  asserta(aksiTerakhir(Kartu))
	  ;
	  true
	),
	aplikasiEfek(EfekSetelah).

/* Uni Invalid */
uni(_) :-
	giliran(Pemain),
	format('[!] Perintah uni tidak valid! ~w mendapat 1 kartu penalti.~n', [Pemain]),
	tarikKartu(Pemain, 1),
    giliranSelanjutnya, !.

/* Tangkap Valid */
tangkap(Target) :-
    giliran(Pemanggil),
    Pemanggil \= Target,
    kartuPemain(Target, DaftarKartuTarget),
    h_ListLength(DaftarKartuTarget, 1),
    uniStatus(DaftarUni),
    \+ h_ListIsMember(Target, DaftarUni),
    !,
    format('[!] ~w TERTANGKAP! Lupa menyerukan UNI.~n', [Target]),
    format('[i] ~w terpaksa mengambil 2 kartu penalti.~n', [Target]),
    tarikKartu(Target, 2),
    giliranSelanjutnya.

/* Tangkap Invalid*/
tangkap(_) :-
    giliran(Pemanggil),
    write('[!] Perintah tangkap tidak valid. '), nl,
    format('[i] ~w mendapatkan 1 kartu penalti.~n', [Pemanggil]),
    tarikKartu(Pemanggil, 1),
    giliranSelanjutnya, !.

/* Tantang berhasil */
tantang :-
    discardTop(kartu(hitam, wildDrawFour)),
    giliranSebelumnya(PemainSebelumnya),
    \+ canPlayWildDrawFour(PemainSebelumnya),
    !,

    write('[i] Tantangan dilakukan'), nl,
    format('[i] Memeriksa kartu ~w...~n', [PemainSebelumnya]),
    format('[i] Tantangan BERHASIL! ~w ketahuan melakukan bluffing.~n', [PemainSebelumnya]),
    format('[i] ~w terpaksa mengambil 4 kartu penalti.~n', [PemainSebelumnya]),

    tarikKartu(PemainSebelumnya, 4),
    retractall(ancamanHukuman(_)),
    asserta(ancamanHukuman(false)),
    giliranSelanjutnya.

/* Tantang gagal */
tantang :-
    discardTop(kartu(hitam, wildDrawFour)),
    giliran(PemainSekarang),
    giliranSebelumnya(PemainSebelumnya),
    canPlayWildDrawFour(PemainSebelumnya),
    !,

    write('[i] Tantangan dilakukan'), nl,
    format('[i] Memeriksa kartu ~w...~n', [PemainSebelumnya]),
    format('[i] Tantangan GAGAL! ~w terbukti jujur.~n', [PemainSebelumnya]),
    format('[i] ~w terkena penalti tambahan dan mengambil 6 kartu.~n', [PemainSekarang]),

    tarikKartu(PemainSekarang, 6),
    retractall(ancamanHukuman(_)),
    asserta(ancamanHukuman(false)),
    giliranSelanjutnya.

/* Tantang invalid */
tantang :-
    write('[!] Perintah tidak dapat dilakukan. Kartu discard sekarang bukan wild draw four'), nl.
