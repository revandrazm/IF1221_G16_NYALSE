/* ===== AKSI UTAMA ===== */
mainkanKartu(Indeks) :-
    giliran(Pemain),
    kartuPemain(Pemain, DaftarKartu),
    h_ListLength(DaftarKartu, JumlahKartu),
    /* Validasi Indeks */
    (	1 =< Indeks, Indeks =< JumlahKartu
    	->
     	IndeksNormal is Indeks-1,
     	h_ListAtIndex(DaftarKartu, IndeksNormal, Kartu),

      /* Validasi Kartu */
      (	kartuMainValid(Kartu)
      	->
		    h_ListRemoveAtIndex(DaftarKartu, IndeksNormal, DaftarKartuBaru),
		    retract(kartuPemain(Pemain, _)),
		    asserta(kartuPemain(Pemain, DaftarKartuBaru)),
		    retract(discardTop(_)),
		    asserta(discardTop(Kartu)),
		    Kartu = kartu(Warna, _),
		    h_ListLength(DaftarKartuBaru, SisaKartu),
		    (SisaKartu \= 1 -> hapusStatusUni(Pemain) ; true),
		    (Warna \= hitam -> retractall(warnaAktif(_)), asserta(warnaAktif(Warna)) ; true),
		    cls,
		    format('~w memainkan kartu: ', [Pemain]),
		    h_FormatCard(Kartu), write('.'), nl,
		    giliranSelanjutnya, !
			;
				write('WARNING: Kartu '), h_FormatCard(Kartu), write(' tidak valid!'), !
			)
		;
			format('WARNING: Indeks ~w tidak valid!~nIndeks Valid: [1-~w]',[Indeks,JumlahKartu]), !
		).

ambilKartu :-
    giliran(Pemain),
    kartuPemain(Pemain, DaftarKartuLama),
    discardTop(kartu(_, JenisDiscard)),
    (   JenisDiscard == drawTwo         -> Jumlah = 2 ;
        JenisDiscard == wildDrawFour    -> Jumlah = 4 ;
        Jumlah = 1  ),
    ambilSejumlahKartu(Jumlah, KartuBaru),
    h_ListAppendList(DaftarKartuLama, KartuBaru, DaftarKartuBaru),
    retract(kartuPemain(Pemain, DaftarKartuLama)),
    asserta(kartuPemain(Pemain, DaftarKartuBaru)),
    hapusStatusUni(Pemain),
    format('Kartu ~w telah diperbarui. Kartu sekarang: ~w~n', [Pemain, DaftarKartuBaru]),
    giliranSelanjutnya.

ambilSejumlahKartu(JumlahKartu, DaftarKartuTerpilih) :-
    deck(DeckAwal),
    prosesAmbil(JumlahKartu, DeckAwal, DeckSisa, DaftarKartuTerpilih),
    retract(deck(DeckAwal)),
    asserta(deck(DeckSisa)).

prosesAmbil(0, Deck, Deck, []) :- !.
prosesAmbil(JumlahKartu, [KartuTeratas|SisaDeckTersedia], DeckAkhir, [KartuTeratas|SisaAmbilan]) :-
    JumlahKartu > 0,
    JumlahSisa is JumlahKartu - 1,
    prosesAmbil(JumlahSisa, SisaDeckTersedia, DeckAkhir, SisaAmbilan).

/* ===== UNI & TANGKAP ===== */
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
uni(Indeks):-
	giliran(Pemain),
    kartuPemain(Pemain,DaftarKartu),
	h_ListLength(DaftarKartu, 2),
	h_ListGetElement(DaftarKartu, Indeks, Kartu),
    kartuMainValid(Kartu),
	!,
	h_ListRemoveAtIndex(DaftarKartu, Indeks, DaftarKartuBaru),
	retract(kartuPemain(Pemain, _)),
    asserta(kartuPemain(Pemain, DaftarKartuBaru)),
	retract(discardTop(_)),
    asserta(discardTop(Kartu)),
	tambahStatusUni(Pemain),
	format('~w memainkan kartu: ',[Pemain]),
    h_FormatCard(Kartu), write('.'), nl,
	format('~w menyerukan UNI!', [Pemain]), nl,
	giliranSelanjutnya.

/* Uni Invalid */
uni(_) :-
	giliran(Pemain),
	format('Perintah uni tidak valid! ~w mendapat 1 kartu penalti.', [Pemain]), nl,
	ambilSejumlahKartu(1, KartuPenalti),
	kartuPemain(Pemain, DaftarKartuLama),
	h_ListAppendList(DaftarKartuLama, KartuPenalti, DaftarKartuBaru),
	retract(kartuPemain(Pemain, _)),
	asserta(kartuPemain(Pemain, DaftarKartuBaru)),
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
    format('~w tertangkap tidak menyerukan UNI.', [Target]), nl,
    format('~w mendapatkan 2 kartu penalti.', [Target]), nl,
    format('Giliran ~w.', [Pemanggil]),
    ambilSejumlahKartu(2, KartuPenalti),
    h_ListAppendList(DaftarKartuTarget, KartuPenalti, DaftarKartuBaru),
    retract(kartuPemain(Target, _)),
    asserta(kartuPemain(Target, DaftarKartuBaru)).

/* Tangkap Invalid*/
tangkap(_) :-
    giliran(Pemanggil),
    write('Perintah tangkap tidak valid. '),
    format('~w mendapatkan 1 kartu penalti.', [Pemanggil]), nl,
    ambilSejumlahKartu(1, KartuPenalti),
    kartuPemain(Pemanggil, DaftarKartuLama),
    h_ListAppendList(DaftarKartuLama, KartuPenalti, DaftarKartuBaru),
    retract(kartuPemain(Pemanggil, _)),
    asserta(kartuPemain(Pemanggil, DaftarKartuBaru)).
