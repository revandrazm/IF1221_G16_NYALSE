:- include('aksi_utama.pl').
:- include('facts.pl').
:- include('ambilKartu.pl').

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
		giliran(Pemain), kartu_pemain(Pemain,ListKartu),
		urutan_pemain(UrutanPemain),
		h_ListIndexOf(UrutanPemain, Pemain, IdPemain),
		h_ListLength(UrutanPemain, NPemain),
		h_ListLength(ListKartu,2),
		h_ListGetElement(ListKartu,Index,Kartu), kartuMainValid(Kartu),

		!,

		h_ListRemoveAtIndex(ListKartu, Index, ListKartuNew),
	  retract(kartu_pemain(Pemain, _)), asserta(kartu_pemain(Pemain, ListKartuNew)),
	  retract(discard_top(_)), asserta(discard_top(Kartu)),
	  add_uni_status(Pemain),

	  format('~w memainkan kartu: ',[Pemain]), h_FormatCard(Kartu), write('.'), nl,
	  format('~w menyerukan UNI!', [Pemain]), nl,
	  arah_permainan(Arah), IdPemain2 is (IdPemain+NPemain+Arah) mod NPemain,
	  h_ListAtIndex(UrutanPemain, IdPemain2, Pemain2),
	  retract(giliran(_)), asserta(giliran(Pemain2)),
	  format('Giliran ~w.', [Pemain2]).

/* Uni Invalid */
uni(_) :-
	  giliran(Pemain), urutan_pemain(UrutanPemain),
	  h_ListIndexOf(UrutanPemain, Pemain, IdPemain),
	  h_ListLength(UrutanPemain, NPemain),
	  format('Perintah uni tidak valid! ~w mendapat 1 kartu penalti.', [Pemain]), nl,

	  ambilSejumlahKartu(1, Penalti),
	  kartu_pemain(Pemain, KartuLama),
	  h_ListAppendList(KartuLama, Penalti, KartuBaru),
	  retract(kartu_pemain(Pemain, _)),
	  asserta(kartu_pemain(Pemain, KartuBaru)),

	  arah_permainan(Arah), IdPemain2 is (IdPemain+NPemain+Arah) mod NPemain,
	  h_ListAtIndex(UrutanPemain, IdPemain2, Pemain2),
	  retract(giliran(_)), asserta(giliran(Pemain2)),
	  format('Giliran ~w.', [Pemain2]).

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
    asserta(kartu_pemain(Pemanggil, KartuBaru)).
