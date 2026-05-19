:- include('state.pl').
:- include('turn.pl').
:- include('utils.pl').
:- include('deck.pl').

/* ===== AKSI UTAMA ===== */
mainkanKartu(Idx) :-
    giliran(Pemain), urutan_pemain(Urutan), h_ListIndexOf(Urutan, Pemain, IdPemain), h_ListLength(Urutan, NPemain), kartu_pemain(Pemain, Deck), h_ListLength(Deck, N), efek_aktif(Efek),
    0 =< Idx, Idx < N,
    h_ListAtIndex(Deck, Idx, Kartu),
    % kartuMainValid(Kartu),
    h_ListRemoveAtIndex(Deck, Idx, Deck2),
    retract(kartu_pemain(Pemain,_)), asserta(kartu_pemain(Pemain,Deck2)),
    format('~w memainkan kartu: ~w', [Pemain,Kartu]), /*formatCard(Kartu),*/ write('.'), nl,

    retract(efek_aktif(Efek)),


    giliranSelanjutnya.

ambilKartu :-
    giliran(Pemain),
    kartu_pemain(Pemain, KartuSebelum),
    discard_top(kartu(W, J)),

    (J == drawTwo -> Jumlah = 2 ;
     J == drawFour -> Jumlah = 4 ;
     Jumlah = 1),

    ambilSejumlahKartu(Jumlah, KartuBaru),
    h_ListAppendList(KartuSebelum, KartuBaru, KartuSesudah),

    retract(kartu_pemain(Pemain, KartuSebelum)),
    asserta(kartu_pemain(Pemain, KartuSesudah)),

    format('Kartu ~w telah diperbarui. Kartu sekarang: ~w~n', [Pemain, KartuSesudah]).

ambilSejumlahKartu(Jumlah, ListKartuTerpilih) :-
    deck(DekAwal),
    prosesAmbil(Jumlah, DekAwal, DekSisa, ListKartuTerpilih),
    retract(deck(DekAwal)),
    asserta(deck(DekSisa)).

prosesAmbil(0, Dek, Dek, []) :- !.
prosesAmbil(Jumlah, Dek, DekAkhir, [Kartu|Sisa]) :-
    h_ListLength(Dek, Length),
    random(0, Length, IndeksPilih),
    h_ListGetElement(Dek, IndeksPilih, Kartu),
    h_ListRemoveAtIndex(Dek, IndeksPilih, DekSisa),
    JumlahBaru is Jumlah - 1,
    prosesAmbil(JumlahBaru, DekSisa, DekAkhir, Sisa).

/* ===== UNI & TANGKAP ===== */
/* Helpers */
add_uni_status(Pemain) :-
		uni_status(List),
	  (\+ h_ListIsMember(Pemain, List) ->
		    retract(uni_status(_)),
		    asserta(uni_status([Pemain|List]))
	  ;
	    	true
	  ).

remove_uni_status(Pemain) :-
		uni_status(List),
	  ( h_ListIsMember(Pemain, List) ->
		    h_ListIndexOf(List,Pemain,Index),
		    h_ListRemoveAtIndex(List,Index,NewList),
		    retract(uni_status(_)),
		    asserta(uni_status(NewList))
	  ;
	    	true
	  ).

/* Uni Valid */
uni(Index):-
		giliran(Pemain), kartu_pemain(Pemain,ListKartu), h_ListLength(ListKartu,2),
		h_ListGetElement(ListKartu,Index,Kartu), kartuMainValid(Kartu),

		!,

		h_ListRemoveAtIndex(ListKartu, Index, ListKartuNew),
	  retract(kartu_pemain(Pemain, _)), asserta(kartu_pemain(Pemain, ListKartuNew)),
	  retract(discard_top(_)), asserta(discard_top(Kartu)),
	  add_uni_status(Pemain),

	  format('~w memainkan kartu: ',[Pemain]), h_FormatCard(Kartu), write('.'), nl,
	  format('~w menyerukan UNI!', [Pemain]), nl,
	  giliranSelanjutnya.

/* Uni Invalid */
uni(_) :-
		giliran(Pemain),
		format('Perintah uni tidak valid! ~w mendapat 1 kartu penalti.', [Pemain]), nl,

	  ambilSejumlahKartu(1, Penalti),
	  kartu_pemain(Pemain, KartuLama),
	  h_ListAppendList(KartuLama, Penalti, KartuBaru),
	  retract(kartu_pemain(Pemain, _)),
	  asserta(kartu_pemain(Pemain, KartuBaru)),

	  giliranSelanjutnya, !.

/* Tangkap Valid */
tangkap(Target) :-
    giliran(Pemanggil),
    Pemanggil \= Target,
    kartu_pemain(Target, ListKartuTarget),
    h_ListLength(ListKartuTarget, 1),
    uni_status(ListUni),
    \+ h_ListIsMember(Target, ListUni),

    !,

    format('~w tertangkap tidak menyerukan UNI.', [Target]), nl,
    format('~w mendapatkan 2 kartu penalti.', [Target]), nl,
    format('Giliran ~w.', [Pemanggil]),

    ambilSejumlahKartu(2, Penalti),
    h_ListAppendList(ListKartuTarget, Penalti, ListKartuBaru),
    retract(kartu_pemain(Target, _)),
    asserta(kartu_pemain(Target, ListKartuBaru)).

/* Tangkap Invalid*/
tangkap(Target) :-
    giliran(Pemanggil),

    write('Perintah tangkap tidak valid. '),
    format('~w mendapatkan 1 kartu penalti.', [Pemanggil]), nl,

    ambilSejumlahKartu(1, Penalti),
    kartu_pemain(Pemanggil, KartuLama),
    h_ListAppendList(KartuLama, Penalti, KartuBaru),
    retract(kartu_pemain(Pemanggil, _)),
    asserta(kartu_pemain(Pemanggil, KartuBaru)),!.
