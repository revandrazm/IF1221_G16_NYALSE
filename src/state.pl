/* Fundamental Dynamics */
:- dynamic(giliran/1).				  % Nama pemain
:- dynamic(urutanPemain/1).		  % List nama []
:- dynamic(arahPermainan/1).	  % kanan/kiri (terpengaruh reverse)
:- dynamic(discardTop/1).			  % Kartu terakhir
:- dynamic(warnaAktif/1).			  % Bisa beda akibat wild
:- dynamic(kartuPemain/2).		  % Nama pemain, list kartu []
:- dynamic(deck/1).					    % Sisa kartu di deck
:- dynamic(uniStatus/1).			  % List pemain yg sudah uni
:- dynamic(gameRunning/1).

/* Bonus */
