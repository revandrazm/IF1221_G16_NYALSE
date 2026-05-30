/* Fundamental Dynamics */
:- dynamic(giliran/1).				  % Nama pemain
:- dynamic(urutan_pemain/1).		% List nama []
:- dynamic(arah_permainan/1).		% kanan/kiri (terpengaruh reverse)
:- dynamic(discard_top/1).			% Kartu terakhir
:- dynamic(warna_aktif/1).			% Bisa beda akibat wild
:- dynamic(kartu_pemain/2).			% Nama pemain, list kartu []
:- dynamic(deck/1).					    % Sisa kartu di deck
:- dynamic(uni_status/1).			  % List pemain yg sudah uni
:- dynamic(efek_aktif/1).       % Efek yang sedang aktif (skip, reverse, drawTwo, drawFour)

/* Fundamental Dynamics */
:- dynamic(giliran/1).				% Nama pemain
:- dynamic(urutanPemain/1).		% List nama []
:- dynamic(arahPermainan/1).		% kanan/kiri (terpengaruh reverse)
:- dynamic(discardTop/1).			% Kartu terakhir
:- dynamic(warnaAktif/1).			% Bisa beda akibat wild
:- dynamic(kartuPemain/2).			% Nama pemain, list kartu []
:- dynamic(deck/1).					% Sisa kartu di deck
:- dynamic(uniStatus/1).			% List pemain yg sudah uni
:- dynamic(gameRunning/1).

/* Bonus */