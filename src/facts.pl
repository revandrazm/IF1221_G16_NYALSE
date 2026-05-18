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
kartuHitam([kartu(hitam, wild), kartu(hitam, wildDrawFour)]).
nilaiKartu(0, 0).
nilaiKartu(1, 1).
nilaiKartu(2, 2).
nilaiKartu(3, 3).
nilaiKartu(4, 4).
nilaiKartu(5, 5).
nilaiKartu(6, 6).
nilaiKartu(7, 7).
nilaiKartu(8, 8).
nilaiKartu(9, 9).
nilaiKartu(skip, 10).
nilaiKartu(reverse, 10).
nilaiKartu(draw_two, 10).
nilaiKartu(wild, 20).
nilaiKartu(wild_draw_four, 20).