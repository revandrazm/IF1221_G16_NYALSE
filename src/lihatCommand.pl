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
