## Tema 2 - Stegano - IOCLA

In aceasta tema am aplicat criptarea/decriptarea unui mesaj in/din imagini folosind mai multe metode:
    
    
    1. Bruteforce pe XOR cu cheie de un octet
        In acest task am decriptarea un mesaj folosind XOR cu o cheie de un octet prin Bruteforce facand un loop de la 0 la 255 incercand sa verific daca se 
    gaseste un cuvant dat din mesaj final.
        Am facut o functie care imi parcurge imaginea si imi cauta litera de inceput a cuvantului cautat ,sarind daca o gaseste la urmatoare litera pana ajunge 
    la ultima liter cautata .Daca gaseste cuvantul se intoarce la inceputul randului si imi iese din functie.
    In parcurgerea matricei am mai luat un contor care imi numara linile astfel salvand la iesire linia pe care am gasit mesajul si un contor care ma anunta
    daca am ajuns la finalul unei lini.La inceput caluclez dimensiunea vectorului(matrice se salveaza ca o zona continua de memorie) si salvez rezultatul pe stiva
    ca sa il am si pentru urmatoarele chei.
    Dupa ce ies din functie printez caracter cu caracter pana la intalnirea terminatorului de sir alaturi de cheia si linia la care l-am gasit.

    2. Criptare folosind XOR cu cheie predefinita
        In acest task trebuie sa introduc un nou mesaj in imaginea decriptata de la 1 pe linia urmatoare folosind criptand imaginea dupa cu o noua cheie 
    calculata dupa formula : key = floor((2 * old_key + 3) / 5) - 4. 
        Am apelat functia de parcurgere de la task-ul 1 si am introdus un sirul nou pe linia imediat urmatoare caracter cu caracter(intelesesem ca nu aveam 
    voie sa folosesc .data). Dupa cea am introdus mesajul am calculat cheia si am xorat intreaga matrice cu cheia obtinuta printand noua imagine folosind functia
    print_image.

    3. Criptarea unui mesaj folosind Codul Morse
        In acest task am criptat un mesaj incepand de la o pozitie data in linie de comanda folosind codificarea Codul-ui Morse astfel.
        Am citit mesajul si pozitia din linia de comanda. Am parcurs in matrice pana la pozitia indicata si am luat caracter cu caracter din mesaj si am 
    codificat dupa fiecare litera sarind la un label care punea in matrice incepand cu pozitia indicata un spatiu(daca nu era primul caracter) si codificarea 
    specifica fiecarui caracter. 
    Task-ul se termina cand am ajuns la terminatorul de sir. 

    4. LSB
        In acest task trebuie sa criptam folosind cel mai nesemnificativ bit (LSB) astef:
        Primim un string si un numar in linie de comanda . Incepanda de la numarul respectiv facem codara mesajului. Ca sa codam trebuie sa luam fiecare bit din
    fiecare caracter al cuvantului si sa il adunam la finalul elementelor din matrice incepand de la pozitia data.
    La implementare am parcurs matrice pana la indicele respectiv ,am sallvat in edx mesajul respectiv si am facut o masca de biti incepand cu cel mai semificativ bit 
    facnd test cu masca si caracterul din mesaj. La fiecare shiftam bitul la dreapta pana se face 0 cand mergeam la urmatorul caracter din mesaj repetand 
    pana gasim 8 biti consecutivi de 0.
    Ca sa adaugam bitul la finalul elementelor din matirce facem shift la dreapta si apoi la stanga stfel bitul cel mai nesemificativ devine 0 astfel cand adunam 
    0 sau 1(asta depinde de rezultatul instructiuni test) se pune in locul ramas liber.

    5. Decriptare LSB 
        In acest task facem operatia inversa task-ului 4 scotand mesajul din elementele matricei incepand cu o pozitie data in linie de comanda.
    Citim valoarea (o convertim cu atoi nr la fel si pentru celelate task-uri) si parcurgem matrice pana la indicele respectiv .
    Dupa aceea facem edi-ul si esi-ul 0 si incepem sa scoatem bitul cel mai ne semnificativ din fiecare element al matricei facand AND cu valoarea 1.
    Rezultatul il punem in esi facand OR cu esi si el shiftand la stanga ca sa faca loc pentru urmatorul. Pentru fiecare caracter format avem un conto care cand am
    terminat de format caracterul sare la un label in care compara daca am ajuns la final( daca caracterul format este "\0" astef iesind ) si face o shiftare la 
    dreapta (la iesire o sa se faca o shiftare in plus) si afiseaza caracterul trecand la urmatorul daca nu sa gasit terminatorul de sir.
    Task-ul se termina la gasirea lui "\0"

    6. Aplicarea unui filtru pe imagine - Nu am mai avut timp sa il implementez 
    
###[Cerinta](https://ocw.cs.pub.ro/courses/iocla/teme/tema-2)    
    
