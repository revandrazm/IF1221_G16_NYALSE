:- include('facts.pl').

loadKartu(ListKartu):- (findall(kartu(W, J), kartu(W, J), ListKartu)).

shuffle(Awal, Hasil) :-
    random_permutation(Awal, Hasil).

    
