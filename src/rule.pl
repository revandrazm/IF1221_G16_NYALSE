

/* Validitas Kartu */
kartuMainValid(kartu(Warna, Jenis)) :-
    discardTop(kartu(_, JenisDiscard)),
    warnaAktif(WarnaAktif),
    ( (Warna = WarnaAktif, Warna \= hitam)
    ; (Jenis = JenisDiscard, Warna \= hitam)
    ; (Jenis = wild, JenisDiscard \= wild)
    ; (Jenis = wildDrawFour, JenisDiscard \= wildDrawFour)
    ).

canPlayWildDrawFour(Pemain) :-
    kartuPemain(Pemain, DaftarKartu),
    \+ cekAdaKartuValid(DaftarKartu).

cekAdaKartuValid([kartu(Warna, Jenis|_]) :- 
    discardTop(kartu(_, JenisDiscard)),
    warnaAktif(WarnaAktif),
    ( (Warna = WarnaAktif, Warna \= hitam)
    ; (Jenis = JenisDiscard, Warna \= hitam)
    !.
cekAdaKartuValid([_|T]) :-
    cekSeluruhKartu(T).


