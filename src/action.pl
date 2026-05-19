:- include('state.pl').
:- include('turn.pl').
:- include('utils.pl').
:- include('deck.pl').

/* ===== AKSI UTAMA ===== */
mainkanKartu(Indeks) :-
    giliran(Pemain), 
    urutanPemain(Urutan),
    kartuPemain(Pemain, DaftarKartu),
    h_ListLength(DaftarKartu, JumlahKartu),
    0 =< Indeks, Indeks < JumlahKartu,
    h_ListAtIndex(DaftarKartu, Indeks, Kartu),
    % kartuMainValid(Kartu),
    h_ListRemoveAtIndex(DaftarKartu, Indeks, DaftarKartuBaru),
    retract(kartu_pemain(Pemain, _)),
    asserta(kartu_pemain(Pemain, DaftarKartuBaru)),
    format('~w memainkan kartu: ', [Pemain]), 
    h_FormatCard(Kartu), write('.'), nl,
    giliranSelanjutnya.

ambilKartu :-
    giliran(Pemain),
    kartuPemain(Pemain, DaftarKartuLama),
    discardTop(kartu(_, JenisDiscard)),
    (   JenisDiscard == drawTwo     -> Jumlah = 2 ;
        JenisDiscard == drawFour    -> Jumlah = 4 ;
        Jumlah = 1  ),
    ambilSejumlahKartu(Jumlah, KartuBaru),
    h_ListAppendList(DaftarKartuLama, KartuBaru, DaftarKartuBaru),
    retract(kartu_pemain(Pemain, DaftarKartuLama)),
    asserta(kartu_pemain(Pemain, DaftarKartuBaru)),
    format('Kartu ~w telah diperbarui. Kartu sekarang: ~w~n', [Pemain, DaftarKartuBaru]),
    giliranSelanjutnya.

ambilSejumlahKartu(0, []) :- !.
ambilSejumlahKartu(Jumlah, [Kartu|Sisa]) :-
    loadKartu(DeckKartu),
    random(0, 54, IndeksPilih),
    h_ListGetElement(DekKartu, IndeksPilih, Kartu),
    JumlahSisa is Jumlah - 1,
    ambilSejumlahKartu(JumlahSisa, Sisa).

/* ===== UNI & TANGKAP ===== */
/* Helpers */
tambahStatusUni(Pemain) :-
	uniStatus(DaftarUni),
	(   \+ h_ListIsMember(Pemain, DaftarUni) 
    ->  retract(uniStatus(_)), 
        asserta(uniStatus([Pemain|DaftarUni])) 
    ;   true 
    ).

hapusStatusUni(Pemain) :-
	uniStatus(DaftarUni),
	(   h_ListIsMember(Pemain, DaftarUni) 
    ->  h_ListIndexOf(DaftarUni,Pemain,Indeks),
		h_ListRemoveAtIndex(DaftarUni, Indeks, DaftarUniBaru),
		retract(uniStatus(_)),
		asserta(uniStatus(DaftarUniBaru))
	;   true
	).

/* Uni Valid */
uni(Indeks):-
	giliran(Pemain), 
    kartuPemain(Pemain,DaftarKartu),
	urutanPemain(UrutanPemain),
	h_ListIndexOf(UrutanPemain, Pemain, IdPemain),
	h_ListLength(UrutanPemain, JumlahPemain),
	h_ListLength(DaftarKartu, 2),
	h_ListGetElement(DaftarKartu, Indeks, Kartu), 
    kartuMainValid(Kartu),
	!,
	h_ListRemoveAtIndex(DaftarKartu, Indeks, DaftarKartuBaru),
	retract(kartu_pemain(Pemain, _)), 
    asserta(kartu_pemain(Pemain, DaftarKartuBaru)),
	retract(discard_top(_)), 
    asserta(discard_top(Kartu)),
	tambahStatusUni(Pemain),
	format('~w memainkan kartu: ',[Pemain]), 
    h_FormatCard(Kartu), write('.'), nl,
	format('~w menyerukan UNI!', [Pemain]), nl,
	arahPermainan(Arah), 
    IdPemainBerikutnya is (IdPemain + JumlahPemain + Arah) mod JumlahPemain,
	h_ListAtIndex(UrutanPemain, IdPemainBerikutnya, PemainBerikutnya),
	retract(giliran(_)), 
    asserta(giliran(PemainBerikutnya)),
	format('Giliran ~w.', [PemainBerikutnya]).

/* Uni Invalid */
uni(_) :-
	  giliran(Pemain), 
      urutanPemain(UrutanPemain),
	  h_ListIndexOf(UrutanPemain, Pemain, IdPemain),
	  h_ListLength(UrutanPemain, JumlahPemain),
	  format('Perintah uni tidak valid! ~w mendapat 1 kartu penalti.', [Pemain]), nl,
	  ambilSejumlahKartu(1, KartuPenalti),
	  kartuPemain(Pemain, DaftarKartuLama),
	  h_ListAppendList(DaftarKartuLama, KartuPenalti, DaftarKartuBaru),
	  retract(kartu_pemain(Pemain, _)),
	  asserta(kartu_pemain(Pemain, DaftarKartuBaru)),
	  arahPermainan(Arah), 
      IdPemainBerikutnya is (IdPemain + JumlahPemain + Arah) mod JumlahPemain,
	  h_ListAtIndex(UrutanPemain, IdPemainBerikutnya, PemainBerikutnya),
	  retract(giliran(_)), 
      asserta(giliran(PemainBerikutnya)),
	  format('Giliran ~w.', [PemainBerikutnya]).

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
tangkap(Target) :-
    giliran(Pemanggil),
    write('Perintah tangkap tidak valid. '),
    format('~w mendapatkan 1 kartu penalti.', [Pemanggil]), nl,
    ambilSejumlahKartu(1, KartuPenalti),
    kartu_pemain(Pemanggil, DaftarKartuLama),
    h_ListAppendList(DaftarKartuLama, KartuPenalti, DaftarKartuBaru),
    retract(kartuPemain(Pemanggil, _)),
    asserta(kartuPemain(Pemanggil, DaftarKartuBaru)).
