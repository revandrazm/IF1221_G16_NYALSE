:- include('utils.pl').

urutan_pemain(['1','2','3','4','5','AB']).
giliran('1').
discard_top(kartu(1,'skip')).
warna_aktif(1).
arah_permainan('kanan').
kartu_pemain('1', [kartu(1,2), kartu(2,3), kartu(3,4)]).
kartu_pemain('2', [kartu(1,2), kartu(2,3), kartu(3,4)]).
kartu_pemain('3', [kartu(1,2)]).
kartu_pemain('4', [kartu(1,2)]).
kartu_pemain('5', [kartu(1,2), kartu(2,3), kartu(3,4)]).
kartu_pemain('AB', [kartu(1,2)]).

saveGame :-
  write('Masukkan nama file penyimpanan: '), read(BaseName) , atom_concat(BaseName,'.txt', FileName), nl,
  write(BaseName),
  open(FileName, write, Stream),
  urutan_pemain(Urutan), format(Stream, 'urutan_pemain(~q).~n', [Urutan]),
  giliran(Giliran), format(Stream, 'giliran(~q).~n', [Giliran]),
  discard_top(Top), format(Stream, 'discard_top(~q).~n', [Top]),
  warna_aktif(Warna), format(Stream, 'warna_aktif(~q).~n', [Warna]),
  arah_permainan(Arah), format(Stream, 'arah_permainan(~q).~n', [Arah]),
  pemainUNI(PemainUni), format(Stream, 'uni_status(~q).~n', [PemainUni]),
  writeSemuaKartuPemain(Urutan, Stream),
  close(Stream),

  format('Status permainan berhasil disimpan ke ~w', [FileName]).

loadGame :-
  write('Masukkan nama file penyimpanan: '), read(BaseName), atom_concat(BaseName, '.txt', FileName), nl,
  open(FileName, read, Stream),
  read(Stream, Urutan), retractall(urutan_pemain(_)), asserta(Urutan),
  read(Stream, Giliran), retractall(giliran(_)), asserta(Giliran),
  read(Stream, Top), retractall(discard_top(_)), asserta(Top),
  read(Stream, Warna), retractall(warna_aktif(_)), asserta(Warna),
  read(Stream, Arah), retractall(arah_permainan(_)), asserta(Arah),
  read(Stream, PemainUni), retractall(pemain_uni(_)), asserta(PemainUni),
  loadKartuPemain(Stream),

  format('Status permainan berhasil dimuat dari ~w.', [FileName]).

format_card_to_program(Card, kartu(W,J)) :- type(X,Card), write(X), atom_codes(Card, C), format_card_to_program(Card, Warna, Jenis, 0, C), atom_codes(W, Warna), atom_codes(J, Jenis).
format_card_to_program(Card, [H|T], Jenis, 0, [H|T]) :- H \= "-".
format_card_to_program(Card, T, Jenis, 0, [H|T]) :- H == "-", format_card_to_program(Card, T, Jenis, 1, T).
format_card_to_program(Card, Warna, [H|T], 1, [H|T]) :- H \= end_of_file.
format_card_to_program(Card, Warna, T, 1, [H|T]) :- H == end_of_file.

format_deck_to_program([H|T], [H2|T2]) :- format_card_to_program(H, H2).
format_deck_to_program([], []).

loadKartuPemain(Stream) :- urutan_pemain(Urutan), loadKartuPemain(Stream, Urutan).
loadKartuPemain(Stream, []).
loadKartuPemain(Stream, [H|T]) :- read(Stream, KartuPemain), retractall(kartu_pemain(H,_)), asserta(KartuPemain), loadKartuPemain(Stream, T).

writeSemuaKartuPemain([], _Stream).
writeSemuaKartuPemain([H|T], Stream) :-
  writeKartuPemain(H, Stream), format(Stream,'.~n', []), writeSemuaKartuPemain(T, Stream).

writeKartuPemain(Pemain, Stream) :-
  kartu_pemain(Pemain, DaftarKartu), format(Stream, 'kartu(~q,~q)', [Pemain, DaftarKartu]).

pemainUNI(Result) :- urutan_pemain(Urutan), pemainUNI(Urutan, Result).

pemainUNI([], []).
pemainUNI([H|T], [H|T2]) :-
  kartu_pemain(H, Deck), h_ListLength(Deck, N), N=:=1, pemainUNI(T, T2).
pemainUNI([H|T], T2) :-
  kartu_pemain(H, Deck), h_ListLength(Deck, N), N=\=1, pemainUNI(T, T2).
