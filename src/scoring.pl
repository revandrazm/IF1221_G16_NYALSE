:- include('state.pl').
:- include('deck.pl').
:- include('player.pl').
:- include('utils.pl').

hitungPoinHelper([], 0).
hitungPoinHelper([kartu(_,J)|T], TotalPoin) :-
    nilaiKartu(J, Nilai),
    hitungPoinHelper(T, PoinSekarang),
    TotalPoin is PoinSekarang + Nilai.
hitungPoinPemain(Pemain, Poin) :-
    kartu_pemain(Pemain, SisaKartu),
    hitungPoinHelper(SisaKartu, Poin).
hitungPoinKeseluruhanHelper([], []).
hitungPoinKeseluruhanHelper([PemainNow|SisaPemain], [(PemainNow, Poin)|SisaPemainPoin]) :-
    hitungPoinPemain(PemainNow, Poin),
    hitungPoinKeseluruhanHelper(SisaPemain, SisaPemainPoin).
hitungPoinKeseluruhan(ListPoin) :-
    urutan_pemain(ListPemain),
    hitungPoinKeseluruhanHelper(ListPemain, ListPoin).

insertSorted(X, [], [X]).
insertSorted((PemainA, PoinA), [(PemainB, PoinB)|TUrut], [(PemainA, PoinA), (PemainB, PoinB)|TUrut]) :-
    PoinA < PoinB,
    !.
insertSorted((PemainA, PoinA), [(PemainB, PoinB)|TUrut], [(PemainA, PoinA), (PemainB, PoinB)|TUrut]) :-
    PoinA =:= PoinB,
    kartu_pemain(PemainA, KartuA),
    h_ListLength(KartuA, JumlahKartuA),
    kartu_pemain(PemainB, KartuB),
    h_ListLength(KartuB, JumlahKartuB),
    JumlahKartuA =< JumlahKartuB,
    !.
insertSorted((PemainA, PoinA), [H|TUrut], [H|TResult]) :-
    insertSorted((PemainA, PoinA), TUrut, TResult).
insertionSort([], []).
insertionSort([H|T], SortedResult) :-
    insertionSort(T, SortedTail),
    insertSorted(H, SortedTail, SortedResult).
rankPemain(ListPoin, RankPoin) :-
    insertionSort(ListPoin, RankPoin).

printKartu([Kartu]) :- 
    h_FormatCard(Kartu),
    write(' = ').
printKartu([Kartu|T]) :-
    h_ListLength(T, L),
    L > 0, !,
    h_FormatCard(Kartu),
    write(' + '),
    printKartu(T).
printPoin([kartu(_, J)]) :-
    nilaiKartu(J, P),
    format('~w = ', [P]).
printPoin([kartu(_, J)|T]) :-
    h_ListLength(T, L),
    L > 0, !,
    nilaiKartu(J, P),
    format('~w + ', [P]),
    printPoin(T).
printSkor([]) :- !.
printSkor([(Pemain, Poin)|Sisa]) :-
    kartu_pemain(Pemain, []), !, 
    format('~w: kartu habis = ~w poin~n', [Pemain, Poin]),
    printSkor(Sisa).
printSkor([(Pemain, Poin)|Sisa]) :-
    kartu_pemain(Pemain, Kartu),
    format('~w: ', [Pemain]), 
    printKartu(Kartu), 
    printPoin(Kartu), 
    format('~w poin~n', [Poin]),
    printSkor(Sisa).
printRank([], _) :- !.
printRank([(Pemain, Poin)|Sisa], I) :-
    format('~w. ~w (~w Poin)~n', [I, Pemain, Poin]),
    I2 is I + 1,
    printRank(Sisa, I2).

endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu.~n'),
    hitungPoinKeseluruhan(ListPoin),
    printSkor(ListPoin),
    rankPemain(ListPoin, RankPoin),
    format('~nUrutan pemenang:~n', []),
    printRank(RankPoin, 1),
    format('~nSelamat ~w menjadi pemenang!~n', [Pemenang]).

gameOverCheck(Pemenang):-
    giliran(Pemenang),
    kartu_pemain(Pemenang, Kartu),
    h_ListLength(Kartu, JumlahKartu),
    JumlahKartu =:= 0.