:- include('facts.pl').
:- include('helper.pl').

/* Helper */
formatCard(kartu(Warna,Jenis)):-
	format('~w-~w',[Warna, Jenis]).
formatCard(Warna, Jenis) :-
	format('~w-~w',[Warna, Jenis]).

lihatHelper([], _) :- !.
lihatHelper([[Warna, Jenis]|T], N) :-
	format('~d. ', [N]), formatCard(Warna, Jenis), nl,
	N2 is N+1,
	lihatHelper(T,N2).

/*
printUrutan([], _) :- .
printUrutan([H|T], N):-
*/

/* Utama */
lihatKartu :-
	giliran(Player), kartu_pemain(Player, Deck), nl,
	write('Berikut kartu yang anda miliki'), nl,
	lihatHelper(Deck,1).

cekInfo :-
	asserta(discard_top(kartu('hitam',wildcard'))),
	discard_top(Top), urutan_pemain(Urutan), arah_permainan(Arah),
	reverse(Urutan,UrutanRev),
	write('Kartu discard top: '), formatCard(Top).
