/* Fundamental Dynamics */

:- dynamic(giliran/1).					% Nama pemain
:- dynamic(urutan_pemain/1).		% List nama []
:- dynamic(arah_permainan/1).		% kanan/kiri (terpengaruh reverse)
:- dynamic(discard_top/1).			% Kartu terakhir
:- dynamic(warna_aktif/1).			% Bisa beda akibat wild
:- dynamic(kartu_pemain/2).			% Nama pemain, list kartu []
:- dynamic(deck/1).							% Sisa kartu di deck
:- dynamic(uni_status/1).				% List pemain yg sudah uni

/* Bonus */
