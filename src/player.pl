/* Inisialisasi pemain awal */
inisialisasiPemain(JumlahPemain, DaftarPemain) :-
    inputNama(JumlahPemain, [], DaftarPemainUtuh),
    h_Shuffle(DaftarPemainUtuh, DaftarPemainAcak),
    DaftarPemain = DaftarPemainAcak,
    assertz(urutanPemain(DaftarPemain)),
    [PemainPertama|_] = DaftarPemain,
    assertz(giliran(PemainPertama)).

/* Input nama pemain */
inputNama(0, Akumulasi, Akumulasi) :- !.
inputNama(JumlahPemain, Akumulasi, Hasil) :-
    JumlahPemain > 0,
    write('[?] Masukkan nama pemain (Bungkus dengan petik satu dan akhiri dengan titik): '),
    read(Nama),
    name(Nama, [ASCIIAwal|_]),
    (   (ASCIIAwal < 65 ; ASCIIAwal > 90)
    ->  write('[!] Nama harus diawali huruf kapital!'), nl,
        inputNama(JumlahPemain, Akumulasi, Hasil)
    ;   h_ListIsMember(Nama, Akumulasi)
    ->  write('[!] Nama sudah digunakan, gunakan nama lain!'), nl,
        inputNama(JumlahPemain, Akumulasi, Hasil)
    ;   JumlahPemainSisa is JumlahPemain - 1,
        h_ListAppendElement(Akumulasi, Nama, AkumulasiBerikutnya),
        inputNama(JumlahPemainSisa, AkumulasiBerikutnya, Hasil)
    ).

/* Pembagian kartu kepada pemain */
bagiKartu([], Deck, Deck).
bagiKartu([Pemain|SisaPemain], Deck, SisaDeck):-
    ambilKartuAwal(KartuPemain, 7, Deck, DeckSementara),
    assertz(kartuPemain(Pemain, KartuPemain)),
    bagiKartu(SisaPemain, DeckSementara, SisaDeck).

ambilKartuAwal([], 0, Deck, Deck) :- !.
ambilKartuAwal([KartuTerambil|SisaAmbilan], JumlahKartuDiambil, [KartuTerambil|SisaDeck], DeckAkhir) :-
    JumlahKartuDiambil > 0,
    SisaJumlahKartuDiambil is JumlahKartuDiambil - 1,
    ambilKartuAwal(SisaAmbilan, SisaJumlahKartuDiambil, SisaDeck, DeckAkhir).
