% Deklarasi fakta dinamis
:- dynamic(kartu_pemain/2).		% Nama pemain, list kartu []
:- dynamic(giliran/1).					% Nama pemain
:- dynamic(urutan_pemain/1).		% List nama []
:- dynamic(deck/1).						% Sisa kartu di deck
:- dynamic(discard_top/1).			% Kartu terakhir
:- dynamic(warna_aktif/1).			% Bisa beda akibat wild
:- dynamic(arah_permainan/1).	% kanan/kiri (terpengaruh reverse)

/* Daftar Kartu Valid*/
kartu(merah, skip).
kartu(merah, reverse).
kartu(merah, drawTwo).
kartu(merah, 0).
kartu(merah, 1).
kartu(merah, 2).
kartu(merah, 3).
kartu(merah, 4).
kartu(merah, 5).
kartu(merah, 6).
kartu(merah, 7).
kartu(merah, 8).
kartu(merah, 9).
kartu(kuning, skip).
kartu(kuning, reverse).
kartu(kuning, drawTwo).
kartu(kuning, 0).
kartu(kuning, 1).
kartu(kuning, 2).
kartu(kuning, 3).
kartu(kuning, 4).
kartu(kuning, 5).
kartu(kuning, 6).
kartu(kuning, 7).
kartu(kuning, 8).
kartu(kuning, 9).
kartu(biru, skip).
kartu(biru, reverse).
kartu(biru, drawTwo).
kartu(biru, 0).
kartu(biru, 1).
kartu(biru, 2).
kartu(biru, 3).
kartu(biru, 4).
kartu(biru, 5).
kartu(biru, 6).
kartu(biru, 7).
kartu(biru, 8).
kartu(biru, 9).
kartu(hijau, skip).
kartu(hijau, reverse).
kartu(hijau, drawTwo).
kartu(hijau, 0).
kartu(hijau, 1).
kartu(hijau, 2).
kartu(hijau, 3).
kartu(hijau, 4).
kartu(hijau, 5).
kartu(hijau, 6).
kartu(hijau, 7).
kartu(hijau, 8).
kartu(hijau, 9).
kartu(hitam, wild).
kartu(hitam, drawFour).

% Convert fakta kartu ke list

printKartu :-
	loadKartu(X), write(X).
