:- include('facts.pl').

formatCard(Warna, Jenis) :-
	format('~w-~w',[Warna, Jenis]).

lihatHelper([], _) :- !.
lihatHelper([[Warna, Jenis]|T], N) :-
	format('~d. ', [N]), formatCard(Warna, Jenis), nl,
	N2 is N+1,
	lihatHelper(T,N2).

lihatKartu :-
	loadKartu(X) /* <-- masih menggunakan all kartu */, nl,
	write('Berikut kartu yang anda miliki'), nl,
	lihatHelper(X,1).
