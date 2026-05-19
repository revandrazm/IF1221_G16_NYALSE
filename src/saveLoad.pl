:- include('utils.pl').

:- dynamic(urutanPemain/1).
:- dynamic(giliran/1).
:- dynamic(discard_top/1).
:- dynamic(arah/1).
:- dynamic(kartuPemain/2).

urutanPemain([1,2,3,4,5,6]).
giliran(1).
discard_top(kartu('merah','skip')).
arah_permainan('kanan').
kartuPemain(1, [kartu(1,2), kartu(2,3), kartu(3,4)]).
kartuPemain(2, [kartu(1,2), kartu(2,3), kartu(3,4)]).
kartuPemain(3, [kartu(1,2)]).
kartuPemain(4, [kartu(1,2)]).
kartuPemain(5, [kartu(1,2), kartu(2,3), kartu(3,4)]).
kartuPemain(6, [kartu(1,2)]).

saveGame :-
  write('Masukkan nama file penyimpanan: '), read(X), nl,
  open(X, write, Stream),
  urutanPemain(Urutan), format(Stream, 'urutan_pemain:~w.~n', [Urutan]),
  giliran(Giliran), format(Stream, 'giliran:~w.~n', [Giliran]),
  discard_top(kartu(Warna,Jenis)), format(Stream, 'discard_top:~w-~w.~n', [Warna, Jenis]),
  format(Stream, 'warna_aktif:~w.~n', [Warna]),
  arah_permainan(Arah), format(Stream, 'arah_permainan:~w.~n', [Arah]),
  pemainUNI(PemainUni), format(Stream, 'status_UNI:~w.~n', [PemainUni]),
  close(Stream),

  format('Status permainan berhasil disimpan ke ~w.txt', [X]).

pemainUNI(Result) :- urutanPemain(Urutan), pemainUNI(Urutan, Result).

pemainUNI([], []).
pemainUNI([H|T], [H|T2]) :-
  kartuPemain(H, Deck), h_ListLength(Deck, N), N=:=1, pemainUNI(T, T2).
pemainUNI([H|T], T2) :-
  kartuPemain(H, Deck), h_ListLength(Deck, N), N=\=1, pemainUNI(T, T2).
