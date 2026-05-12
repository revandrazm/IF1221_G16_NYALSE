:- include('facts.pl').
:- include('helper.pl').

/* Helper */
formatCard(kartu(Warna,Jenis)):-
	format('~w-~w',[Warna, Jenis]).

lihatHelper([], _) :- !.
lihatHelper([kartu(Warna,Jenis)|T], N) :-
	format('~d. ', [N]), formatCard(kartu(Warna, Jenis)), nl,
	N2 is N+1,
	lihatHelper(T,N2).

formatUrutanHelp([]) :- !.
formatUrutanHelp([H|T]) :-
	write(' - '), write(H),
	formatUrutan(T).

formatUrutan([H|T]):-
	write(H),
	formatUrutanHelp(T).

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
	discard_top(Top), urutan_pemain(Urutan), arah_permainan(Arah),
	reverse(Urutan,UrutanRev),
	write('Kartu discard top: '), formatCard(Top), nl, nl,
	write('Urutan pemain: '), formatUrutan(Urutan), nl, nl.
