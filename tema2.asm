%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text
global main

functie_task_1:
     push ebp               ; pun pe stiva base pointer-ul vechi
     mov ebp, esp           ; pun in ebp ,esp
     
    xor edx,edx             
    mov eax,[img_width]     ; salvez width-ul si height-ul pentru inmultire    
    mov ebx,[img_height]
    mul ebx
  
    push eax                ; salvez o copie a rezultatului pe stiva 
 
    xor ebx,ebx             ; facem 0 nr elementelor de pe linie
    mov ecx,[img]           ; pun in ecx pointer-ul la primul element din matrice  
    mov ebx,0               ; initializare cheie cu 0
    mov edi,1               ; initializare contor cu 1
    

   
parcurgere_matrice_Task_1:
    xor esi,esi                 
    add esi,dword[ecx]      ; copiere in esi a valori din matrice    
    xor esi,ebx             ; xorare copie cu cheie
   
    cmp esi,'r'             ; cautare in imagine a literei 'r'     
    je daca_e               ; daca sa gasit sarim si cautam litera 'e'
 
    inc edx                 ; incrementam nr elementelor de pe linie  
    add ecx,4               ; mergem la urmatorul element 
    dec eax                 ; decrementam lungimea totala
    
continua:
    cmp eax,0               ; daca am ajuns cu lungimea la 0    
    je next_key             ; mergem la urmatoarea cheie 
    
    cmp edx,[img_width]                     ; daca am ajuns la finalul liniei         
    je resetare_numarare_linie_Task_1       ; jmp la resetare linie 
    jmp parcurgere_matrice_Task_1           ; daca nu continuam
    
    
next_key:                    ; trecerea la urmatoarea cheie    
    
    xor edx,edx              ; resetam nr de elemente de pe coloana     
    xor edi,edi              ; resetam nr linilor     
    pop eax                  ; scoatem de pe stiva lungimea salvata    
    push eax                 ; o salvam la loc pentru urmatoarea cheie     
    inc ebx                  ; marim cheia    
    mov ecx,[img]            ; salvam in ecx inceputul matricei   
    cmp ebx,256              ; daca am ajuns al 256 
    je done                  ; iesim din cautarea mesajului     
                         
    jmp parcurgere_matrice_Task_1 ; daca nu incepem de la inceput 
    
resetare_numarare_linie_Task_1:     
    mov edx,0                      ; resetam nr elementelor de pe linie  
    inc edi                        ; incrementam nr liniei 
    jmp parcurgere_matrice_Task_1  ;continuam parcurgerea  
    
intoarecere_la_inceputul_liniei:   ; intoarcere la inceputul liniei unde sa gasit 'revient'   
  
    dec edx                        ; decrementam edx        
    sub ecx,4                      ; scadem cu 4 valoarea pointerului din ecx 
                             
    cmp edx,0                      ; daca nu am ajuns la inceputul randului 
    jne intoarecere_la_inceputul_liniei  ; decrementam recursiv 
    
    jmp iesire_functie_task_1            ; daca da iesim din functie                

;urmatoarele 6 label-uri verifica pe rand daca exista literele cuvantului 'revient'
;daca da ,ajung in t,sare la intoarecere_la inceputul_liniei si iese din functie 
;daca nu ,se intoarece in parcurgere si cauta in continuare  

daca_t:                            
    inc edx                                 ; incrementeaza edx-ul 
    add ecx,4                               ; trece la urmatorul element 
    dec eax                                 ; decrementeaza eax-ul
    xor esi,esi                             
    add esi,dword[ecx]                      ; salveaza intr-un registru valoarea de xorat 
    xor esi,ebx                             ; xoreaza registrul cu cheia 
    cmp esi,'t'                             ; daca este urmatorul element <urmatoare litera din cuvant>
    je intoarecere_la_inceputul_liniei  ; sare la label-ul care verifica urmatoare litera la rand pana ajunge la ultima litera din cuvant  
    jmp continua                        ; daca nu sa gasit se reintoarce in parcurgere         

daca_n:
    inc edx
    add ecx,4
    dec eax
    xor esi,esi
    add esi,dword[ecx]
    xor esi,ebx
    cmp esi,'n'
    je daca_t
    jmp continua

daca_e_e:
    inc edx
    add ecx,4
    dec eax
    xor esi,esi
    add esi,dword[ecx]
    xor esi,ebx
    cmp esi,'e'
    je daca_n
    jmp continua    
    
daca_i:
    inc edx
    add ecx,4
    dec eax
    xor esi,esi
    add esi,dword[ecx]
    xor esi,ebx
    cmp esi ,'i'
    je daca_e_e
    jmp continua

daca_v:
    inc edx
    add ecx,4
    dec eax
    xor esi,esi
    add esi,dword[ecx]
    xor esi,ebx
    cmp esi,'v'
    je daca_i
    jmp continua

daca_e:

    inc edx
    add ecx,4
    dec eax
    xor esi,esi
    add esi,dword[ecx]
    xor esi,ebx
    cmp esi,'e'
    je daca_v
    jmp continua
    
;end

iesire_functie_task_1:   ; iesire functie  
    leave
    ret


main:
    mov ebp, esp; for correct debugging
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
 
    xor eax,eax         ;xoram eax 
    xor ebx,ebx         ;si ebx
    call functie_task_1 ;apelam functia functie_task_1 care parcurge si imi gaseste 
                        ;cheia si randul unde se gaseste mesajul 
                        
;iesim din functie cu pozitia de inceput a mesajului alaturi de linie si cheie
 
print_mesaj_task_1:     ;parcurgem si afisam caracterele linia pana gasim terminatorul de sir      

    xor esi,esi         
    add esi,dword[ecx]  ; salvam si xoram fiecare caracter
    xor esi,ebx
   
    add ecx,4           ; mergem la urmatorul caracter     
    cmp esi,0           ; verificam daca am ajuns la terminatorul de sir 
    je stop             ; daca da iesim 
        
    PRINT_CHAR esi      ; daca nu printam caracterul     
    
    jmp print_mesaj_task_1  ; jmp la printare_mesaj_task_1 verificam urmatorul element 

stop:  ; sa terminat de printat mesajul  
    
    NEWLINE
    PRINT_DEC 4,ebx     ; printam cheia si
    NEWLINE
    PRINT_DEC 4,edi     ; linia fiecare pe cate o linie noua     

    jmp done            ; jmp la done 
    
solve_task2:
    ; apelam functia de parcurgere de la task-ul 1
        xor eax,eax        
        xor ebx,ebx
        call functie_task_1
    ;end
   
    push ebx        ; salvam pe stiva a cheii 
    
    xor edx,edx         ; refolosim ebx-ul
    ; calculam lungimea totala si salvam in eax
        mov eax,[img_width] 
        mov ebx,[img_height]
        mul ebx
    ;end
    
    pop ebx         ; resatoram cheia 
    push eax        ; salvam lungimea matricei pe stiva
    mov ecx ,[img]  ; ii dam lui ecx pointer la primul element din imagine
    
xor_cu_key:
    
    xor dword[ecx],ebx ; xoram elementele din matrice  
    add ecx,4          ; mergem la urmatorul elemnt      
    dec eax            ; decrementam eax
    cmp eax,0          ; daca am ajjuns la final 
    je inserare_element_sir_nou ; terminam parcurgerea 
    jmp xor_cu_key     ; daca nu mergem sa xoram urmatorul element  
    
inserare_element_sir_nou:  
 
    pop eax             ; scoatem lungimea matricei    
    push eax            ; o salvam la loc 
    
    mov ecx ,[img]      ; ii dam lui ecx pointer la primul element din imagine    
    xor edx,edx         ; xoram nr de emente de pe linie 
    mov esi,1           ; setez contorul linilor la 1
    inc edi             ; incrementez linia unde trebuie sa inserez noul mesaj
    
salt_la_inserare_mesaj:

    cmp edx,[img_width]         ; daca am ajuns la finalul liniei 
    je salt_la_resetare_linie   ; sar la resetare linie

    cmp esi,edi                 ; daca a am ajuns la linia dorita 
    jg calcul_key               ; sar afara din parcurgere                 
    inc edx                     ; incrementez lungimea liniei
    add ecx,4                   ; merg la urmatorul element din matrice
    dec eax                     ; decrementez lungimea totala

    jmp salt_la_inserare_mesaj   ; repet pana am ajuns la linia dorita    
    
salt_la_resetare_linie:
         
    mov edx,0                   ; reetez nr elementelor de pe linie            
    inc esi                     ;incrementez esi
    jmp salt_la_inserare_mesaj  ;ma intorc la parcurgere
    
calcul_key:    
; intrduc mesajul litera cu litera in matrice
    mov dword[ecx],"C"
    add ecx,4
    mov dword[ecx],"'"
    add ecx,4
    mov dword[ecx],"e"
    add ecx,4    
    mov dword[ecx],"s"
    add ecx,4    
    mov dword[ecx],"t"
    add ecx,4    
    mov dword[ecx]," "
    add ecx,4    
    mov dword[ecx],"u"
    add ecx,4    
    mov dword[ecx],"n"
    add ecx,4    
    mov dword[ecx]," "
    add ecx,4    
    mov dword[ecx],"p"
    add ecx,4    
    mov dword[ecx],"r"
    add ecx,4    
    mov dword[ecx],"o"
    add ecx,4    
    mov dword[ecx],"v"
    add ecx,4    
    mov dword[ecx],"e"
    add ecx,4    
    mov dword[ecx],"r"
    add ecx,4    
    mov dword[ecx],"b"
    add ecx,4    
    mov dword[ecx],"e"
    add ecx,4    
    mov dword[ecx]," "
    add ecx,4    
    mov dword[ecx],"f"
    add ecx,4    
    mov dword[ecx],"r"
    add ecx,4    
    mov dword[ecx],"a"
    add ecx,4    
    mov dword[ecx],"n"
    add ecx,4    
    mov dword[ecx],"c"
    add ecx,4    
    mov dword[ecx],"a"
    add ecx,4    
    mov dword[ecx],"i"
    add ecx,4    
    mov dword[ecx],"s"
    add ecx,4    
    mov dword[ecx],"."
    add ecx,4    
    mov dword[ecx],0
;end
     
    mov ecx,[img]  ; mut inceputul maticei in ecx

;calculez noua cheie dupa formula key = floor((2 * old_key + 3) / 5) - 4                 
    xor edx,edx
    mov eax,2       
    mul ebx
    
    add eax,3
    XOR edx,edx
    
    mov ebx,5
    div ebx
            
    sub eax,4
    mov ebx,eax
;end    
 
     pop eax   ; scot din stiva lungimea totala matricei 
   
    
xor_cu_newkey:
    
    xor dword[ecx],ebx  ; xorez fiecare element cu noua cheie salvata in ebx 
    add ecx,4           ; merg la urmatorul element 
    dec eax             ; dectrementez lungimea totala        
    cmp eax,0           ; compar daca am ajuns la final
    je final_task_2     ; daca da ies din xorare cu noua cheie
    jmp xor_cu_newkey   ; daca nu continui 
   
final_task_2:

; apelez functia print_image , argumentele punanduse pe stiva in ordine inversa 
    
    push dword[img_height]  
    push dword[img_width]
    push dword[img]
    call print_image
;end 
    jmp done   ; terminare task 2
    
solve_task3:
 
    mov ebx,[ebp+12] ;salvez in ebx zona de inceput 
                     ;a argumentelor din linia de comanda 
   
; apel functie atoi    
    push DWORD[ebx + 16]    ; push pe stiva a lui argv[4]
    call atoi               ; apelez atoi
    add esp, 4              ; curat stiva dupa iesire 
;end     
    mov ecx,[img]           ; salvez adresa s=de inceput a imagini     
    xor edi,edi             ; xorez edi

; parcurgem imaginea pana la elementul din argv[4]    
parcurgere_task_3:          

    add ecx,4
    inc edi
    cmp edi,eax
    
    je iesire_parcurgere
    jmp parcurgere_task_3
    
;end    

iesire_parcurgere:    
   
    mov edx,[ebx+12]        ; salvam in edx argv[3] care reprezint mesajul ce trebuie criptat
    mov ebx,0xffffffff      ; punem in ebx -1
    xor eax,eax             ; xoram eax
continuare_cuvant:    
    inc ebx                 ; incrementam contorul caracterului 
    mov al,byte[edx+ebx]    ; mutam in al caracterul 
    
;verificam daca caracterul este A,B,C,..,X,Z,1,2,..,8,9,0," ",sau "," daca da 
; sarim la codificarea specifica pt fiecare carater    
    cmp al,"A"
    je salt_A
     cmp al,"B"
    je salt_B
     cmp al,"C"
    je salt_C
     cmp al,"D"
    je salt_D
     cmp al,"E"
    je salt_E
     cmp al,"F"
    je salt_F
     cmp al,"G"
    je salt_G
     cmp al,"H"
    je salt_H
     cmp al,"I"
    je salt_I
     cmp al,"J"
    je salt_J
    cmp al,"K"
    je salt_K
     cmp al,"L"
    je salt_L
     cmp al,"M"
    je salt_M
     cmp al,"N"
    je salt_N
     cmp al,"O"
    je salt_O
     cmp al,"P"
    je salt_P
     cmp al,"Q"
    je salt_Q
     cmp al,"R"
    je salt_R
     cmp al,"S"
    je salt_S
     cmp al,"T"
    je salt_T
     cmp al,"U"
    je salt_U
     cmp al,"V"
    je salt_V
     cmp al,"W"
    je salt_W
     cmp al,"X"
    je salt_X
     cmp al,"Y"
    je salt_Y
     cmp al,"Z"
    je salt_Z
     cmp al,"1"
    je salt_1
     cmp al,"2"
    je salt_2
     cmp al,"3"
    je salt_3
     cmp al,"4"
    je salt_4
     cmp al,"5"
    je salt_5
     cmp al,"6"
    je salt_6
     cmp al,"7"
    je salt_7
     cmp al,"8"
    je salt_8
     cmp al,"9"
    je salt_9
     cmp al,"0"
    je salt_0
     cmp al," "
    je salt_spatiu
     cmp al,","
    je salt_virgula
     
;end
     cmp al,0           ; daca sa terminat sirul
    je final_task_3     ; sarim la final    
    
; codificarile pentru fiecare caracter    
salt_A:
    cmp ebx,0                   ;daca caracterul nu este primul adaugam un spati 
    jne adauga_spatiuA
continua_A:                     ;codificarea propriuzisa 
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuA:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_A 
      
salt_B:
    cmp ebx,0
    jne adauga_spatiuB
continua_B:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuB:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_B   

salt_C:
    cmp ebx,0
    jne adauga_spatiuC
continua_C:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuC:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_C   


salt_D:
    cmp ebx,0
    jne adauga_spatiuD
continua_D:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuD:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_D   

salt_E:
    cmp ebx,0
    jne adauga_spatiuE
continua_E:
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuE:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_E 
      
salt_F:
    cmp ebx,0
    jne adauga_spatiuF
continua_F:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuF:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_F   

salt_G:
    cmp ebx,0
    jne adauga_spatiuG
continua_G:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuG:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_G
    
    
salt_H:
    cmp ebx,0
    jne adauga_spatiuH
continua_H:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuH:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_H   

salt_I:
    cmp ebx,0
    jne adauga_spatiuI
continua_I:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
   
    jmp continuare_cuvant
adauga_spatiuI:
    
    mov dword[ecx]," "
    add ecx,4
    jmp continua_I  

salt_J:
    cmp ebx,0
    jne adauga_spatiuJ
continua_J:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuJ:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_J 
      
salt_K:
    cmp ebx,0
    jne adauga_spatiuK
continua_K:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuK:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_K
       
salt_L:
    cmp ebx,0
    jne adauga_spatiuL
continua_L:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuL:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_L 
      
salt_M:
    cmp ebx,0
    jne adauga_spatiuM
continua_M:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    
    jmp continuare_cuvant
adauga_spatiuM:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_M 
    
salt_N:
    cmp ebx,0
    jne adauga_spatiuN
continua_N:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
   
    jmp continuare_cuvant
adauga_spatiuN:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_N   
    
salt_O:
    cmp ebx,0
    jne adauga_spatiuO
continua_O:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
  
    jmp continuare_cuvant
adauga_spatiuO:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_O   
    
salt_P:
    cmp ebx,0
    jne adauga_spatiuP
continua_P:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuP:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_P   
    
salt_Q:
    cmp ebx,0
    jne adauga_spatiuQ
continua_Q:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuQ:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_Q
    
salt_R:
    cmp ebx,0
    jne adauga_spatiuR
continua_R:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuR:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_R   
    
salt_S:
    cmp ebx,0
    jne adauga_spatiuS
continua_S:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuS:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_S   
    
salt_T:
    cmp ebx,0
    jne adauga_spatiuT
continua_T:
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuT:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_T   
    
salt_U:
    cmp ebx,0
    jne adauga_spatiuU
continua_U:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuU:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_U  
    
salt_V:
    cmp ebx,0
    jne adauga_spatiuV
continua_V:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuV:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_V  
    
salt_W:
    cmp ebx,0
    jne adauga_spatiuW
continua_W:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    
    jmp continuare_cuvant
adauga_spatiuW:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_W   
    
salt_X:
    cmp ebx,0
    jne adauga_spatiuX
continua_X:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuX:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_X  
    
salt_Y:
    cmp ebx,0
    jne adauga_spatiuY
continua_Y:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuY:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_Y  
     
salt_Z:
    cmp ebx,0
    jne adauga_spatiuZ
continua_Z:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuZ:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_Z   
    
salt_1:
    cmp ebx,0
    jne adauga_spatiu1
continua_1:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu1:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_1
       
salt_2:
    cmp ebx,0
    jne adauga_spatiu2
continua_2:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu2:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_2
    
salt_3:
    cmp ebx,0
    jne adauga_spatiu3
continua_3:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu3:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_3
    
salt_4:
    cmp ebx,0
    jne adauga_spatiu4
continua_4:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu4:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_4
    
salt_5:
    cmp ebx,0
    jne adauga_spatiu5
continua_5:
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu5:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_5
    
salt_6:
    cmp ebx,0
    jne adauga_spatiu6
continua_6:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu6:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_6
    
salt_7:
    cmp ebx,0
    jne adauga_spatiu7
continua_7:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu7:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_7
    
salt_8:
    cmp ebx,0
    jne adauga_spatiu8
continua_8:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu8:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_8
    
salt_9:
    cmp ebx,0
    jne adauga_spatiu9
continua_9:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu9:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_9
    
salt_0:
    cmp ebx,0
    jne adauga_spatiu0
continua_0:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiu0:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_0
    
salt_spatiu:
    cmp ebx,0
    jne adauga_spatiuSPATIU
continua_SPATIU:
    mov dword[ecx],"|"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuSPATIU:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_SPATIU
    
salt_virgula:
    cmp ebx,0
    jne adauga_spatiuVIRGULA
continua_VIRGULA:
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"."
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    mov dword[ecx],"-"
    add ecx,4
    jmp continuare_cuvant
adauga_spatiuVIRGULA:
    mov dword[ecx]," "
    add ecx,4
    jmp continua_VIRGULA
;end_codificare_caracter
       
final_task_3:    
    mov dword[ecx],0   ; punem terminatorul de sir 

; printam imaginea 
    push dword[img_height]
    push dword[img_width]
    mov ecx,[img]
    push ecx
    
    call print_image
;end    

    jmp done ;terminare task 3
    
solve_task4:

    mov ebx,[ebp+12];salvez in ebx zona de inceput 
                    ;a argumentelor din linia de comanda 
   
   
; apel functie atoi    
    push DWORD[ebx + 16]    ; push pe stiva a lui argv[4]
    call atoi               ; apelez atoi
    add esp, 4              ; curat stiva dupa iesire 
;end     
   
    
    mov ecx,[img]   ; salvare adrea sa inceput a imagini 
    xor edi,edi     ; xorare edi
  
    mov edi,1       ; initializare edi cu 1
;parcurgerea matricei pana cand ajunge la elementul indicat de argv[4] care
;dupa atoi e in eax
parcurgere_task_4:

    add ecx,4
    inc edi
    cmp edi,eax
    
    je iesire_parcurgere4
    jmp parcurgere_task_4
;end
   
iesire_parcurgere4:   
    mov edx,[ebx+12]  ; salvarea in edx a lui argv[3]
    mov ebx,0xffffffff; initalizare a lui ebx cu -1  
    xor eax,eax       ; xorare eax
    mov eax,1         ; mutare in eax 1 
    
continuare_Task_4:
    inc ebx            ; incrementare a lui ebx 
    cmp eax,0          ; comparam daca am ajuns laterminatorul de sir 
    je final_task_4    ; daca da jump la final 
    xor eax,eax        ; xoram eax 
    mov al,byte[edx+ebx]; salvam in al fiecare caracter din argv[3]
     
    mov edi,1           ; mutm in edi 1
    shl edi,7           ; shiftam pana facem cel mai semnificativ bit 1
   
shiftare:
    cmp edi,0           ; cat timp edi nu e 0 adaugam la ultimul element 0 sau 1
    je continuare_Task_4;daca e 0 mergem la urmatorul caracter
    shr dword[ecx],1    ; shiftam la dreapta iar apoi la stanga ca sa
    shl dword[ecx],1    ; facem loc pentru noul bit 
    test eax,edi        ; testam daca dupa and zf este 1 sau nu      
    je pune_0           ; daca e 1 adaugam la elementul din matrice 0
    jne pune_1          ; daca nu e 1 adaugam la elementul din matrice 1
    
pune_1:
    add dword[ecx],1    ; adaougam 1 la element 
    add ecx,4           ; mergem la urmatorul element din matirce
    shr edi,1           ; shiftam la dreaptacu 1
    jmp shiftare
    
pune_0:
    add dword[ecx],0    ; adaougam 1 la element
    add ecx,4           ; mergem la urmatorul element din matirce
    shr edi,1           ; shiftam la dreaptacu 1
    jmp shiftare           
    
final_task_4:
;printare imagine     
    push dword[img_height]
    push dword[img_width]
    push dword[img]
    call print_image
;end
                          
    jmp done
                
solve_task5:
    mov ebx,[ebp+12]    ;salvez in ebx zona de inceput 
                        ;a argumentelor din linia de comanda 
   
;apel functie atoi    
    push DWORD[ebx + 12]    ; push pe stiva a lui argv[3]
    call atoi               ; apelez atoi
    add esp, 4              ; curat stiva dupa iesire 
;end
    
    mov ecx,[img]       ; salvare adrea sa inceput a imagini 
    xor edi,edi         ; xorare edi
    inc edi             ; incrementez edi ca sa incep de la 1

;parcurgerea matricei pana cand ajunge la elementul indicat de argv[3] care
;dupa atoi e in eax        
parcurgere_task_5:
    
    add ecx,4
    inc edi
    cmp edi,eax
    
    je iesire_parcurgere5
    jmp parcurgere_task_5
;end
   
iesire_parcurgere5:

    xor edi,edi         ; xorare edi si
    xor esi,esi         ; xorare esi cu fiecare parcurgere 
    
next_bite:              
    cmp edi,8           ; daca am terminal 8 numere din matrice afisam caracterul format
    je next_char        ; sarim la next_char care printeaza si caracterul si verifica dacca e termiantorul de sir
    mov edx,dword[ecx]  ; mutam in edx valoarea din matrice 
    
    and edx,1           ; facem si cu 1 sa vedem daca lsb este 1 sau 0
    or esi,edx          ; facem or cu esi (unde formam caracterul) si cu rezultatul din edx
    shl esi,1           ; siftam la stanga rezultatul 
   
    add ecx,4           ; mergem la utrmatorul element din matrice 
    inc edi             ; incrementam edi-ul
    jmp next_bite       ; caluclam rmatorul bit 
next_char:
    shr esi,1           ; shiftam la dreapta cu 1 ( am observat ca imi face o shiftare in plus inainte de afisare astarezolva problema) 
    cmp esi,0           ; daca e terminatorul de sir 
    je done             ; terminam
    PRINT_CHAR esi      ; daca nu printam caracterl     
    
    jmp iesire_parcurgere5  ; si formam caracterul urmator
        
solve_task6:
    ; TODO Task6
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret