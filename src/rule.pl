/* Validitas Kartu */
kartuMainValid(kartu(Warna, Jenis)) :-
    discardTop(kartu(_, JenisDiscard)),
    warnaAktif(WarnaAktif),
    !,
    ( (Warna == WarnaAktif, Warna \= hitam)
    ; (Jenis == JenisDiscard, Jenis \= wild, Jenis \= wildDrawFour)
    ; (Jenis == wild, JenisDiscard \= wild)
    ; (Jenis == wildDrawFour, JenisDiscard \= wildDrawFour)
    ).

canPlayWildDrawFour(Pemain) :-
    kartuPemain(Pemain, DaftarKartu),
    \+ cekAdaKartuValid(DaftarKartu).

cekAdaKartuValid([kartu(Warna, Jenis)|_]) :-
    discardTop(kartu(_, JenisDiscard)),
    warnaAktif(WarnaAktif),
    ( (Warna = WarnaAktif, Warna \= hitam)
    ; (Jenis = JenisDiscard, Warna \= hitam)
    ), !.
cekAdaKartuValid([_|T]) :-
    cekAdaKartuValid(T).

/* Validitas Warna */
cekWarnaValid(merah).
cekWarnaValid(kuning).
cekWarnaValid(hijau).
cekWarnaValid(biru).
