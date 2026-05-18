% Deklarasi fakta dinamis
:- dynamic(kartu_pemain/2).		  % Nama pemain, list kartu []
:- dynamic(giliran/1).					% Nama pemain
:- dynamic(urutan_pemain/1).		% List nama []
:- dynamic(deck/1).						  % Sisa kartu di deck
:- dynamic(discard_top/1).			% Kartu terakhir
:- dynamic(warna_aktif/1).			% Bisa beda akibat wild
:- dynamic(arah_permainan/1).	  % kanan/kiri (terpengaruh reverse)

/* Daftar Kartu Valid*/
warnaDasar([merah, kuning, hijau, biru]).
jenisKartu([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, skip, reverse, drawTwo]).
kartuHitam([kartu(hitam, normal), kartu(hitam, drawFour)]).