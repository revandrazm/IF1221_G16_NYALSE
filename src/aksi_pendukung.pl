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
