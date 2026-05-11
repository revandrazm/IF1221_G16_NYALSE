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
    write('Aksi pendukung yang tersedia:'),
    nl,
    !.

printList([], _).
printList([Head|Tail], N) :-
    format('~w. ~w~n', [N, Head]),
    NNext is N + 1,
    printList(Tail, NNext).
