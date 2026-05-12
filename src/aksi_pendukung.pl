aksiUtama(mainkanKartu(indexKartu)).
aksiUtama(ambilKartu).
aksiUtama(tantang).
aksiUtama(uni(indexKartu)).
aksiUtama(tangkap(namaPemain)).

aksiPendukung(lihatCommand).
aksiPendukung(lihatKartu).
aksiPendukung(cekInfo).

lihatCommand :-
    write('Aksi utama yang tersedia:'),
    nl,
    printAksiUtama,
    nl,
    write('Aksi pendukung yang tersedia:'),
    nl,
    printAksiPendukung,
    !.

printList([], _).
printList([Head|Tail], N) :-
    format('~w. ~w~n', [N, Head]),
    NNext is N + 1,
    printList(Tail, NNext).

printAksiUtama :-
    findall(Aksi, aksiUtama(Aksi), Out),
    printList(Out, 1).

printAksiPendukung :-
    findall(Aksi, aksiPendukung(Aksi), Out),
    printList(Out, 1).
:- include('facts.pl').
:- include('helper.pl').

/* Helper */
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

printUrutan([], _) :- !.
printUrutan([H|T], N):-
	format('Nama pemain ~d: ~s', [N, H]), nl,
	kartu_pemain(H,ListKartu), jumlahKartu(ListKartu,Ans),
	format('Jumlah kartu: ~d', [Ans]), nl, nl.


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
	printUrutan(Urutan, 1).
