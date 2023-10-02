
import time



def passo1(string_a_ser_hasheada):
    string_hasheada = string_a_ser_hasheada
    if len(string_a_ser_hasheada)%16 != 0: #ou seja, se não for multiplo de 16
        caracter_anexado = chr(16 - len(string_a_ser_hasheada)%16)
        while(len(string_hasheada) % 16 != 0):
            
            string_hasheada = string_hasheada + caracter_anexado

    
    return string_hasheada

def passo2(SaidaPassoUm, vetor_magico):
    i = j = 0
    novoBloco =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    novoValor = 0
    n = len(SaidaPassoUm)/16
    while(i <= n - 1):
        while(j <= 15):
            novoValor = vetor_magico[(ord(SaidaPassoUm[i*16 + j]) ^ novoValor)] ^ novoBloco[j]
            novoBloco[j] = novoValor
            j += 1
        
        i += 1
        j = 0

    for i in range(16):
        novoBloco[i] = chr(novoBloco[i])
       
    return novoBloco


def passo3(SaidaPassoDois, vetor_magico):
    
    SaidaPassoTres = []
    for i in range(48):
        SaidaPassoTres.append(0)
    
    i = 0
    while(i <= (len(SaidaPassoDois)/16 - 1)):
        for j in range(16):
            SaidaPassoTres[16+j] = ord(SaidaPassoDois[i*16 + j])
            SaidaPassoTres[2*16 + j] = SaidaPassoTres[16+j] ^ SaidaPassoTres[j]
        temp = 0
        for j in range(18):
            for k in range(48):
                temp = SaidaPassoTres[k] ^ vetor_magico[temp]
                SaidaPassoTres[k] = temp
            temp = (temp + j) % 256
        i += 1
    SaidaPassoTres = [chr(i) for i in SaidaPassoTres]
    return SaidaPassoTres


def print_string_hex(SaidaPasso3):
    for i in SaidaPasso3[:16]:
        print(format(ord(i), "x"), end="")


start_time = time.time()

vetorMagico = [122, 77, 153, 59, 173, 107, 19, 104, 123, 183, 75, 10,
114, 236, 106, 83, 117, 16, 189, 211, 51, 231, 143, 118, 248, 148, 218,
245, 24, 61, 66, 73, 205, 185, 134, 215, 35, 213, 41, 0, 174, 240, 177,
195, 193, 39, 50, 138, 161, 151, 89, 38, 176, 45, 42, 27, 159, 225, 36,
64, 133, 168, 22, 247, 52, 216, 142, 100, 207, 234, 125, 229, 175, 79,
220, 156, 91, 110, 30, 147, 95, 191, 96, 78, 34, 251, 255, 181, 33, 221,
139, 119, 197, 63, 40, 121, 204, 4, 246, 109, 88, 146, 102, 235, 223,
214, 92, 224, 242, 170, 243, 154, 101, 239, 190, 15, 249, 203, 162, 164,
199, 113, 179, 8, 90, 141, 62, 171, 232, 163, 26, 67, 167, 222, 86, 87,
71, 11, 226, 165, 209, 144, 94, 20, 219, 53, 49, 21, 160, 115, 145, 17,
187, 244, 13, 29, 25, 57, 217, 194, 74, 200, 23, 182, 238, 128, 103,
140, 56, 252, 12, 135, 178, 152, 84, 111, 126, 47, 132, 99, 105, 237,
186, 37, 130, 72, 210, 157, 184, 3, 1, 44, 69, 172, 65, 7, 198, 206,
212, 166, 98, 192, 28, 5, 155, 136, 241, 208, 131, 124, 80, 116, 127,
202, 201, 58, 149, 108, 97, 60, 48, 14, 93, 81, 158, 137, 2, 227, 253,
68, 43, 120, 228, 169, 112, 54, 250, 129, 46, 188, 196, 85, 150, 6, 254,
180, 233, 230, 31, 76, 55, 18, 9, 32, 82, 70]

file_path = "texto10000.txt"  

with open(file_path, "r") as file:
    vetor_str = file.readline().strip()



vetor_str = passo1(vetor_str)
buffer = passo2(vetor_str, vetorMagico)
for i in range(16):
    vetor_str = vetor_str + buffer[i]
vetor_str = passo3(vetor_str, vetorMagico)
print_string_hex(vetor_str)

end_time = time.time()
Tempogasto = end_time - start_time
print("\n")
print(f"O tempo foi de : {Tempogasto:.9f} segundos")


