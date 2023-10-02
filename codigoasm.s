
section .text
global _start
_start:



abertura_arquivo:   mov rax, 2;                     Primeiro, vamos abrir o arquivo que queremos ler o conteudo
                    mov rdi, nome_do_arquivo        
                    mov rsi, 0
                    syscall
                    mov [arquivo], rax  

leitura_arquivo:    mov rax, 0
                    mov rdi, [arquivo]  
                    mov rsi, tamanho_da_leitura;    Buffer em que vamos armazenar o texto
                    mov rdx, 100001            ;    100001 pois também devemos levar em conta o enter
                    syscall
                    dec rax;                           rax agora guarda a quantidade de bytes lidos sem contar com o enter

                    mov rdi, quant_de_caracteres_lidos ; Aqui vamos guardar a quantidade de caracteres lidos originalmente
                    mov [rdi], rax
                    xor rcx, rcx



inicio_do_passo1:   and rax, 15                        ; Checagem para ver se a quantidade de caracteres é um multiplo de 16
                    cmp rax, 0
                    jz fim_do_laco_passo1              ; Se ja tivermos um número multiplo de 16, não precisamos fazer o passo1
                   
                    mov r8 ,16                         ; Manipulação para fazer o padding
                    sub r8, rax
                    mov rax, r8
                    xor r8, r8



inicio_do_laco_passo1:  ;nesse laço vamos ter o passo 1 "padding"
                    cmp rcx, rax
                    je fim_do_laco_passo1
                    xor rsi, rsi
                    mov rsi, [quant_de_caracteres_lidos]
                    add rsi, tamanho_da_leitura
                    
                    mov byte [rsi], al ;temos que em al o resultando da operação "and" realizada acima
                                       ;e ele vai ser nossa constante de padding que iremos adicionar  
                    
                    inc rcx
                    mov r9, 1
                    add [quant_de_caracteres_lidos], r9;Incrementa o número de caracteres lidos
                    jmp inicio_do_laco_passo1  
fim_do_laco_passo1:    

                    xor rax, rax;       Limpeza de alguns registradores
                    xor rcx, rcx
                    xor rdx, rdx
                    xor r8, r8  
                    xor r9, r9
fim_do_passo1:

passo2:             mov byte [novo_valor_passo2], 0 ; Manipulação para o calculo de n-1 (utilizamos para o loop)
                    xor rbx, rbx

                    mov rax, [quant_de_caracteres_lidos]
                    mov r10, 16
                    div r10
                    xor r10, r10
                    dec rax

inicio_laco_maior: cmp rcx, rax;  for(i <- 0 to n - 1 do)
                    jg fim_do_laco_maior

inicio_laco_menor: cmp rdx, 15;   for(j <- 0 to 15 do)
                    jg fim_do_laco_menor


                    mov r8, tamanho_da_leitura; Aqui vamos colocar os registradores r8,r9 e r10 para
                    mov r9, novobloco_passo2;   loadarem os valores de endereço inicial desses vetores
                    mov r10, vetorMagico

                    imul r14, rcx, 16; Aqui calculamos saidaPassoUm[i*16 + j]
                    add r14, rdx
                    add r8, r14
                    mov r15b, [r8]; armazenamos o resultado em r15b

                    xor r15, rbx; aqui vamos acessar o indice que calculamos do vetor magico
                    add r10, r15; e iremos armazenar o valor que o vetor magico detém nessa posicao
                    mov r13b, [r10]; em r13b

                    add r9, rdx; Esse bloco é o correspondente ao novoBloco[j] <- novoValor
                    xor r13b, [r9]
                    mov rbx, r13
                    mov [r9], bl

                    xor r8, r8 ;limpeza dos registradores
                    xor r9, r9
                    xor r10, r10
                    xor r14, r14
                    xor r15, r15
                    xor r13, r13
                    xor r12, r12
                    inc rdx ; incrementando o contador do laço
                    jmp inicio_laco_menor



fim_do_laco_menor:  inc rcx
                    xor rdx, rdx
                    jmp inicio_laco_maior



fim_do_laco_maior:  xor rcx, rcx; limpeza dos registradores
                    xor rax, rax
                    xor rbp, rbp
                    mov r9, novobloco_passo2

concatenacao_passo2:cmp rcx, 15
                    jg fim_da_concatenacao; Aqui, vamos precisar concatenar o novoBloco que fabricamos no passo2 no nosso buffer original
                    inc rsi;               precisamos incrementar o rsi aqui pois, como ele segura o buffer, queremos preencher a primeira 
                    mov r10b, [r9];        posicao vaga dele, assim, precisamos que ele rsi esteja segurando o endereço de memoria dessa posicao vaga
                    mov byte[rsi], r10b
                    inc r9
                    inc rcx
                    jmp concatenacao_passo2


fim_da_concatenacao:        

                    xor rcx, rcx;       Limpeza de registradores
                    xor rsp, rsp


passo3:             mov rax, [quant_de_caracteres_lidos]
                    mov r10, 16
                    div r10
                    xor r10, r10
                    mov rsp, rax
                    xor rax, rax
                    


inicio_laco1passo3: cmp rcx, rsp;      Representa, no pseudocódigo, i <- 0 to n do:
                    jg fim_laco1passo3
                    xor rdx, rdx
                    mov r8, tamanho_da_leitura ;tamanho_da_leitura funciona como saida_passo_2 (nosso buffer)                                         
                    mov r9, novobloco_passo3; r9 será o registrador que andará sobre novobloco_passo3


inicio_laco2passo3: cmp rbp, 15;        Representa, no pseudocódigo, j <- 0 to 15 do:
                    jg fim_laco2passo3

                    

                    imul r12, rcx, 16 ; calculo do indice ix16+j
                    add r12, rbp
                    add r8, r12 ; r8 agora aponta para a posição de saidapasso2 com o indice igual a i x 16 + j
                    

                    mov r13, rbp; calculo do indice 16+j
                    add r13, 16
                    add r9, r13; r9 agora aponta para a posição de novobloco_passo3 com o indice de 16+j
                    

                    mov r14b, [r8] ;utilizamos o r14 como um registrador intermediario para
                    mov [r9], r14b; que consigamos colocar o valor de saidapasso2[ix16+j] em 
                    xor r14,r14  ; novobloco_passo3[16+j]
                    
                    mov r14b, [r9]
                    sub r9, 16
                    mov r15b, [r9]
                    xor r14, r15; O registrador r14 irá segurar o valor de SaidaPassoTres[16+j] XOR SaidaPassoTres[j]



                    add r9, 32;   para ajustar o indice para [2x16 + j], basta adicionarmos 2x16 = 32
                    mov [r9], r14
                    
                    mov r8, tamanho_da_leitura; Colocamos r8 e r9 para novamente segurar os primeiros endereços do buffer e do novo bloco
                    mov r9, novobloco_passo3 
                    

                    xor r14,r14         ;incremento de contador e limpeza de registradores
                    xor r15,r15
                    inc rbp
                    jmp inicio_laco2passo3
                    
 fim_laco2passo3:   

                    xor rbp, rbp
                    xor r12,r12 ;r12 representa o temp

 inicio_laco3passo3:cmp r14, 17 ; r14 representa o j, essa comparação representa, no pseudocódigo: for j <- 0 to 17 do:
                    jg fim_laco3passo3
                    mov r10, vetorMagico; o registrador r10 guardará a primeira posição de vetorMagico
                    
 inicio_laco4passo3:cmp r15, 47; Essa comparação representa for k <- 0 to 47 do:
                    jg fim_laco4passo3

                    mov r13b, [r9]; Esse bloco representa a linha temp <- saidaPassoTres[k] XOR vetorMagico[temp]
                    add r10, r12
                    xor r13b, [r10]
                    mov r10, vetorMagico; coloco r10 para segurar novamente o primeiro endereço de memória de vetorMagico
                    mov r12b, r13b
                    

                    mov byte [r9], r12b; Esse bloco representa a linha saidaPassoTres[k] <- temp
                    inc r9; incremento de r9 para a iteração sobre novobloco_passo3
                    inc r15
                    jmp inicio_laco4passo3



 fim_laco4passo3:   mov r9, novobloco_passo3; Esse bloco representa a linha temp <- (temp+j)%256
                    xor r15, r15 
                    add r12, r14
                    mov rax, r12
                    mov rbx, 256
                    xor rdx, rdx
                    div rbx
                    mov r12, rdx
                    inc r14
                    jmp inicio_laco3passo3
 fim_laco3passo3:

                    xor r15, r15
                    inc rcx
                    jmp inicio_laco1passo3                   
 fim_laco1passo3:      
                 
                    mov r15, novobloco_passo3

 fim_passo3:


 inicio_passo4:     xor r10, r10;               limpeza dos registradores
                    xor rcx, rcx
                    xor rdx, rdx
                    xor rbx, rbx
                    xor rsi, rsi
                    xor r15, r15


                    mov r15, 16 ;               Preparação para o laço que vai preencher nosso vetor de print_final
                    mov r8, novobloco_passo3
                    mov r14, print_final
                    
inicio_do_loop:     cmp r15,0
                    je fim_do_loop
                    mov r12, hex_chars; r12 vai guardar o primeiro endereço de hex_chars
                    xor r13, r13
                    mov r13, 16
                    mov byte al, [r8]; coloca em al o primeiro elemento de novobloco_passo3
                    div r13 ;rdx vai ter o resto e rax o quociente
                    
                    mov r9, rax;guarda quociente rm r9
                    mov r10, rdx;guarda resto em r10

                    mov r13, hex_chars; r13 vai gaurdar o segundo endereço de hex_chars

                    add r12, r10; r12 agora guarda o elemento de hex_chars cujo indice é o resto da divisao acima - 1
                    mov byte cl, [r12]



                    add r13, r9; r13 agora guarda o elemento de hex_chars cujo indice é o quociente da divisao acima -1
                    mov byte bl, [r13]

                    xor rdx, rdx
                    mov [r14], bl;  Algarismo hexadecimal mais significativo
                    inc r14
                    mov [r14], cl;  Algarismo hexadecimal menos significativo
                    xor rbx, rbx
                    xor rcx, rcx
                    inc r14
                    dec r15
                    inc r8
                    jmp inicio_do_loop
    

                    xor rbx, rbx
                    xor rcx, rcx

fim_do_loop:        
                    xor r8, r8 ;                Limpeza dos registradores
                    xor r12, r12
                    xor r14, r14
                    xor r10, r10
                    xor r13, r13
                    xor rsp, rsp
                    xor r9, r9
                    xor rdi, rdi
                    xor rax, rax

imprime_a_string:   mov rax, 1;                 Syscall para print
                    mov rdi, 1
                    mov rsi, print_final
                    mov rdx, 32
                    syscall

                    mov rax, 1;                 Syscall para quebra de linha no terminal (estética)
                    mov rdi, 1
                    mov rsi, char_fantasma
                    mov rdx, 1
                    syscall

saida_do_programa:  mov rax, 60;                Syscall para saída do programa
                    xor rdi, rdi
                    syscall





section .data
    hex_chars db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
    
    vetorMagico db 122, 77, 153, 59, 173, 107, 19, 104, 123, 183, 75, 10, 114, 236, 106, 83, 117, 16, 189, 211, 51, 231, 143, 118, 248, 148, 218, 245, 24, 61, 66, 73, 205, 185, 134, 215, 35, 213, 41, 0, 174, 240, 177, 195, 193, 39, 50, 138, 161, 151, 89, 38, 176, 45, 42, 27, 159, 225, 36, 64, 133, 168, 22, 247, 52, 216, 142, 100, 207, 234, 125, 229, 175, 79, 220, 156, 91, 110, 30, 147, 95, 191, 96, 78, 34, 251, 255, 181, 33, 221, 139, 119, 197, 63, 40, 121, 204, 4, 246, 109, 88, 146, 102, 235, 223, 214, 92, 224, 242, 170, 243, 154, 101, 239, 190, 15, 249, 203, 162, 164, 199, 113, 179, 8, 90, 141, 62, 171, 232, 163, 26, 67, 167, 222, 86, 87, 71, 11, 226, 165, 209, 144, 94, 20, 219, 53, 49, 21, 160, 115, 145, 17, 187, 244, 13, 29, 25, 57, 217, 194, 74, 200, 23, 182, 238, 128, 103, 140, 56, 252, 12, 135, 178, 152, 84, 111, 126, 47, 132, 99, 105, 237, 186, 37, 130, 72, 210, 157, 184, 3, 1, 44, 69, 172, 65, 7, 198, 206, 212, 166, 98, 192, 28, 5, 155, 136, 241, 208, 131, 124, 80, 116, 127, 202, 201, 58, 149, 108, 97, 60, 48, 14, 93, 81, 158, 137, 2, 227, 253, 68, 43, 120, 228, 169, 112, 54, 250, 129, 46, 188, 196, 85, 150, 6, 254, 180, 233, 230, 31, 76, 55, 18, 9, 32, 82, 70
    
    nome_do_arquivo db "texto10000.txt", 0 ;COLOQUE O ARQUIVO .TXT QUE ESTÁ DENTRO DO DIRETÓRIO E QUE VOCÊ DESEJA LER

    char_fantasma db  0x0A
    


section .bss
    
    print_final resb 33
    tamanho_da_leitura resb 100017; número de chars do maior num possivel (100k) + o enter
    novo_valor_passo2 resb 1
    novobloco_passo2 resb 16
    novobloco_passo3 resb 48
    buffer_size resb 64
    quant_de_caracteres_lidos resb 32
    arquivo resq 1


