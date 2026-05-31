:- include('utils.pl').

saveGame :-
  write('Masukkan nama file penyimpanan: '), read(BaseName) , atom_concat(BaseName,'.txt', FileName), nl,
  open(FileName, write, Stream),
  urutanPemain(Urutan), format(Stream, 'urutanPemain(~q).~n', [Urutan]),
  giliran(Giliran), format(Stream, 'giliran(~q).~n', [Giliran]),
  discardTop(Top), format(Stream, 'discardTop(~q).~n', [Top]),
  warnaAktif(Warna), format(Stream, 'warnaAktif(~q).~n', [Warna]),
  arahPermainan(Arah), format(Stream, 'arahPermainan(~q).~n', [Arah]),
  pemainUNI(PemainUni), format(Stream, 'uniStatus(~q).~n', [PemainUni]),
  writeSemuaKartuPemain(Urutan, Stream),
  close(Stream),

  format('Status permainan berhasil disimpan ke ~w', [FileName]).

loadGame :-
  write('Masukkan nama file penyimpanan: '), read(BaseName), atom_concat(BaseName, '.txt', FileName), nl,
  open(FileName, read, Stream),
  read(Stream, Urutan), retractall(urutanPemain(_)), asserta(Urutan),
  read(Stream, Giliran), retractall(giliran(_)), asserta(Giliran),
  read(Stream, Top), retractall(discardTop(_)), asserta(Top),
  read(Stream, Warna), retractall(warnaAktif(_)), asserta(Warna),
  read(Stream, Arah), retractall(arahPermainan(_)), asserta(Arah),
  read(Stream, PemainUni), retractall(pemainUni(_)), asserta(PemainUni),
  loadKartuPemain(Stream),

  format('Status permainan berhasil dimuat dari ~w.', [FileName]).


loadKartuPemain(Stream) :- urutanPemain(Urutan), loadKartuPemain(Stream, Urutan).
loadKartuPemain(Stream, []).
loadKartuPemain(Stream, [H|T]) :- read(Stream, KartuPemain), retractall(kartuPemain(H,_)), asserta(KartuPemain), loadKartuPemain(Stream, T).

writeSemuaKartuPemain([], _Stream).
writeSemuaKartuPemain([H|T], Stream) :-
  writeKartuPemain(H, Stream), format(Stream,'.~n', []), writeSemuaKartuPemain(T, Stream).

writeKartuPemain(Pemain, Stream) :-
  kartu_pemain(Pemain, DaftarKartu), format(Stream, 'kartuPemain(~q,~q)', [Pemain, DaftarKartu]).

pemainUNI(Result) :- urutan_pemain(Urutan), pemainUNI(Urutan, Result).

pemainUNI([], []).
pemainUNI([H|T], [H|T2]) :-
  kartu_pemain(H, Deck), h_ListLength(Deck, N), N=:=1, pemainUNI(T, T2).
pemainUNI([H|T], T2) :-
  kartu_pemain(H, Deck), h_ListLength(Deck, N), N=\=1, pemainUNI(T, T2).
