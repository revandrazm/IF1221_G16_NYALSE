:- dynamic(urutanPemain/1).
:- dynamic(giliran/1).
:- dynamic(discard_top/1).
:- dynamic(arah/1).
:- dynamic(kartuPemain/2).

urutanPemain([1,2,3,4,5]).

saveGame :-
  write('Masukkan nama file penyimpanan: '), read(X), nl,
  open(X, write, Stream),
  urutanPemain(Urutan), format(Stream, 'urutan_pemain: ~w', [Urutan]),
  write(Stream, 'giliran:'),
  write(Stream, 'discard_top:'),
  write(Stream, 'warna_aktif:'),
  write(Stream, 'arah_permainan:'),
  write(Stream, 'status_UNI:'),
  close(Stream),

  format('Status permainan berhasil disimpan ke ~w.txt', [X]).
