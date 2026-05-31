:- include('state.pl').
:- include('utils.pl').
:- include('deck.pl').
:- include('player.pl').
:- include('turn.pl').
:- include('effects.pl').
:- include('rule.pl').
:- include('display.pl').
:- include('action.pl').
:- include('bonus.pl').
:- include('scoring.pl').
:- include('fileIO.pl').
:- include('init.pl').

:- initialization(main).

main :-
    nl,
    write('==========================================='), nl,
    write('      MENU UTAMA G-16 NYALSE EDITION       '), nl,
    write('==========================================='), nl,
    write(' [?] Ketik "startGame." untuk bermain.'), nl,
    write(' [?] Ketik "exit." untuk keluar.'), nl,
    write(' >> '),
    read(Command),
    (
        Command == startGame ->
        startGame, 
        main
        ;
        Command == exit ->
        write('[i] Terima kasih telah bermain! Sampai jumpa.'), nl,
        halt
        ;
        write('[!] Perintah tidak dikenali. Pastikan diakhiri dengan titik (.).'), nl,
        main
    ).