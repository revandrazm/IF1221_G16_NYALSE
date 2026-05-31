saveGame :-
  write('[?] Masukkan nama file penyimpanan: '), read(BaseName),
  name(BaseName, BaseString), name('.txt', ExtString), insertTail(BaseString, ExtString, FileString), name(FileName, FileString), nl,
  open(FileName, write, Stream),
  urutanPemain(Urutan), format(Stream, 'urutanPemain(~q).~n', [Urutan]),
  giliran(Giliran), format(Stream, 'giliran(~q).~n', [Giliran]),
  discardTop(Top), format(Stream, 'discardTop(~q).~n', [Top]),
  warnaAktif(Warna), format(Stream, 'warnaAktif(~q).~n', [Warna]),
  arahPermainan(Arah), format(Stream, 'arahPermainan(~q).~n', [Arah]),
  uniStatus(PemainUni), format(Stream, 'uniStatus(~q).~n', [PemainUni]),
  ( 	aksiTerakhir(KartuAksi)
  	->
   		format(Stream, 'aksiTerakhir(~q).~n', [KartuAksi])
    ;
    	format(Stream, 'aksiTerakhir(none).~n', [])
  ),
  (		efekMimic(EfekAktif)
  	->
      format(Stream, 'efekMimic(~q).~n', [EfekAktif])
    ;
    	format(Stream, 'efekMimic(none).~n', [])
  ),
  writeSemuaKartuPemain(Urutan, Stream),
  close(Stream),

  format('[i] Status permainan berhasil disimpan ke ~w', [FileName]).

loadGame :-
  write('[?] Masukkan nama file penyimpanan: '), read(BaseName),
  name(BaseName, BaseString), name('.txt', ExtString), insertTail(BaseString, ExtString, FileString), name(FileName, FileString), nl,
  (catch(open(FileName, read, Stream), _, fail) ->
  read(Stream, Urutan), retractall(urutanPemain(_)), asserta(Urutan),
  read(Stream, Giliran), retractall(giliran(_)), asserta(Giliran),
  read(Stream, Top), retractall(discardTop(_)), asserta(Top),
  read(Stream, Warna), retractall(warnaAktif(_)), asserta(Warna),
  read(Stream, Arah), retractall(arahPermainan(_)), asserta(Arah),
  read(Stream, PemainUni), retractall(uniStatus(_)), asserta(PemainUni),
  read(Stream, Aksi), retractall(aksiTerakhir(_)),
  (Aksi == aksiTerakhir(none) -> true ; asserta(Aksi)),
  read(Stream, Mimic), retractall(efekMimic(_)),
  (Mimic == efekMimic(none) -> true ; asserta(Mimic)),
  loadKartuPemain(Stream),

  format('[i] Status permainan berhasil dimuat dari ~w.~n', [FileName]),
  close(Stream);
  format('[!] File ~w tidak ada!~n', [FileName])
  ).

loadKartuPemain(Stream) :- urutanPemain(Urutan), loadKartuPemain(Stream, Urutan).
loadKartuPemain(_Stream, []).
loadKartuPemain(Stream, [H|T]) :- read(Stream, KartuPemain), retractall(kartuPemain(H,_)), asserta(KartuPemain), loadKartuPemain(Stream, T).

writeSemuaKartuPemain([], _Stream).
writeSemuaKartuPemain([H|T], Stream) :-
  writeKartuPemain(H, Stream), format(Stream,'.~n', []), writeSemuaKartuPemain(T, Stream).

writeKartuPemain(Pemain, Stream) :-
  kartuPemain(Pemain, DaftarKartu), format(Stream, 'kartuPemain(~q,~q)', [Pemain, DaftarKartu]).
