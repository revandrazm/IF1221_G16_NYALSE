:- include('state.pl').
:- include('deck.pl').
:- include('player.pl').
:- include('utils.pl').
:- include('display.pl').

/* Perhitungan Poin */
hitungPoinHelper([], 0).
hitungPoinHelper([kartu(_,Jenis)|Sisa], TotalPoin) :-
    nilaiKartu(Jenis, Nilai),
    hitungPoinHelper(Sisa, AkumulasiPoin),
    TotalPoin is AkumulasiPoin + Nilai.

hitungPoinPemain(Pemain, Poin) :-
    kartuPemain(Pemain, SisaKartu),
    hitungPoinHelper(SisaKartu, Poin).

hitungPoinSemuaHelper([], []).
hitungPoinSemuaHelper([Pemain|SisaPemain], [(Pemain, Poin)|SisaPoin]) :-
    hitungPoinPemain(Pemain, Poin),
    hitungPoinSemuaHelper(SisaPemain, SisaPoin).

hitungPoinSemua(DaftarPoin) :-
    urutanPemain(DaftarPemain),
    hitungPoinSemuaHelper(DaftarPemain, DaftarPoin).

/* Pengurutan Peringkat */
insertSorted(X, [], [X]).
insertSorted((PemainA, PoinA), [(PemainB, PoinB)|SisaUrut], [(PemainA, PoinA), (PemainB, PoinB)|SisaUrut]) :-
    PoinA < PoinB,
    !.
insertSorted((PemainA, PoinA), [(PemainB, PoinB)|SisaUrut], [(PemainA, PoinA), (PemainB, PoinB)|SisaUrut]) :-
    PoinA =:= PoinB,
    kartuPemain(PemainA, KartuA), h_ListLength(KartuA, JumlahKartuA),
    kartuPemain(PemainB, KartuB), h_ListLength(KartuB, JumlahKartuB),
    JumlahKartuA =< JumlahKartuB, !.
insertSorted((PemainA, PoinA), [H|SisaUrut], [H|SisaHasil]) :-
    insertSorted((PemainA, PoinA), SisaUrut, SisaHasil).

insertionSort([], []).
insertionSort([H|Sisa], HasilUrut) :-
    insertionSort(Sisa, SisaUrut),
    insertSorted(H, SisaUrut, HasilUrut).

peringkatPemain(DaftarPoin, PeringkatPoin) :-
    insertionSort(DaftarPoin, PeringkatPoin).

endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu:'), nl,
    hitungPoinSemua(DaftarPoin),
    printSkor(DaftarPoin),
    peringkatPemain(DaftarPoin, PeringkatPoin),
    format('~nUrutan pemenang:~n', []),
    printPeringkat(PeringkatPoin, 1),
    format('~nSelamat ~w menjadi pemenang!~n', [Pemenang]).

cekGameOver(Pemenang):-
    giliran(Pemenang),
    kartuPemain(Pemenang, DaftarKartu),
    h_ListLength(DaftarKartu, JumlahKartu),
    JumlahKartu =:= 0.