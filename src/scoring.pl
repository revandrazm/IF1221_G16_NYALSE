:- include('facts.pl').
:- include('deck.pl').
:- include('player.pl').
:- include('utils.pl').

hitungPoinHelper([], 0).
hitungPoinHelper([kartu(W,J)|T], TotalPoin) :-
    nilaiKartu(J, Nilai),
    hitungPoinHelper(T, PoinSekarang),
    TotalPoin is PoinSekarang + Nilai.
hitungPoinPemain(Pemain, Poin) :-
    kartu_pemain(Pemain, SisaKartu),
    hitungPoinHelper(SisaKartu, Poin).
hitungPoinKeseluruhanHelper([], []).
hitungPoinKeseluruhanHelper([PemainNow|PemainSisa], [(PemainNow, P)|PoinSisa]) :-
    hitungPoinPemain(PemainNow, P),
    hitungPoinKeseluruhanHelper(PemainSisa, PoinSisa).
hitungPoinKeseluruhan(ScoreList) :-
    urutan_pemain(ListPemain),
    hitungPoinKeseluruhanHelper(ListPemain, ScoreList).
insertSorted(X, [], [X]).
insertSorted((PemainA, PoinA), [(PemainB, PoinB)|T], [(PemainA, PoinA), (PemainB, PoinB)|T]) :-
    PoinA < PoinB,
    !.
insertSorted((PemainA, PoinA), [(PemainB, PoinB)|T], [(PemainA, PoinA), (PemainB, PoinB)|T]) :-
    PoinA =:= PoinB,
    kartu_pemain(PemainA, KartuA),
    h_ListLength(KartuA, JumlahKartuA),
    kartu_pemain(PemainB, KartuB),
    h_ListLength(KartuB, JumlahKartuB),
    JumlahKartuA =< JumlahKartuB,
    !.
insertSorted((PemainA, PoinA), [H|T], [H|TResult]) :-
    insertSorted((PemainA, PoinA), T, TResult).
insertionSort([], []).
insertionSort([H|T], SortedResult) :-
    insertionSort(T, SortedTail),
    insertSorted(H, SortedTail, SortedResult).

rankPemain(ScoreList, RankList) :-
insertionSort(ScoreList, RankList).
printKartu([]) :-
    write('kartu habis = ').
printKartu([kartu(W, J)]) :- 
    format('~w-~w = ', [W, J]).
printKartu([kartu(W, J)|T]) :-
    h_ListLength(T, L),
    L > 0, !,
    format('~w-~w + ', [W, J]),
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
    kartu_pemain(Pemain, Kartu),
    format('~w : ', [Pemain]), printKartu(Kartu), printPoin(Kartu), format('~w poin~n', [Poin]),
    printSkor(Sisa).
printRank([], _) :- !.
printRank([(Pemain, Poin)|Sisa], I) :-
    format('~w. ~w (~w Poin)~n', [I, Pemain, Poin]),
    I2 is I + 1,
    printRank(Sisa, I2).

endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n', [Pemenang]),
    hitungPoinKeseluruhan(ScoreList),
    printSkor(ScoreList),
    rankPemain(ScoreList, RankList),
    format('~nUrutan Pemenang:~n', []),
    printRank(RankList, 1),
    format('~nSelamat ~w menjadi pemenang!~n', [Pemenang]).

gameOverCheck(Pemenang):-
    giliran(Pemenang),
    kartu_pemain(Pemenang, Kartu),
    h_ListLength(Kartu, JumlahKartu),
    JumlahKartu =:= 0.