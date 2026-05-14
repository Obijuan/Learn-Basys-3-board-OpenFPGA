    .include "stack.h"

#──────────────────────────────────────────────────────
#──  Convertir un numero binario de 4 bits a un array
#──  de caracteres bcd
#──
#──  Ej. 0101 --> 0000, 0001, 0000, 0001
#── 
#──  ENTRADAS:
#──    a0: Direccion del comienzo del array
#──    a1: Numero a convertir
#──────────────────────────────────────────────────────
    .global bin4_to_bcd_array
bin4_to_bcd_array:

    STACK16

    #-- Establecer el tamaño a 4 bits
    li a2, 4
    jal bin_to_bcd_array

    UNSTACK16


#──────────────────────────────────────────────────────
#──  Convertir un numero binario de n bits a un array
#──  de caracteres bcd
#──
#──  Ej. n=3: 110 --> 0001, 0001, 0000
#── 
#──  ENTRADAS:
#──    a0: Direccion del comienzo del array
#──    a1: Numero a convertir
#──    a2: Tamaño en bits
#──────────────────────────────────────────────────────
    .global bin_to_bcd_array
bin_to_bcd_array:

    #-- t1: Nº de bit (el de mayor peso)
    addi t1, a2, -1

    #-- t0: Mascara del bit actual
    li t2, 1
    sll t0, t2, t1  #-- 1 << t1

1:
    #-- Obtener bit i-simo
    and t2, a1, t0   #-- t2 = n & mask
    srl t2, t2, t1   #-- t2 >> i

    #-- Almacenar bit i
    andi t2, t2, 1   #-- Eliminar todo menos el bit 0
    sb t2, 0(a0)

    #-- Apuntar al siguiente elemento del array
    addi a0, a0, 1

    #-- Siguiente mascara
    srli t0, t0, 1   #-- mask >> 1

    #-- Siguiente bit
    addi t1, t1, -1

    #-- Si mascara es 0, hemos terminado
    bne t0, zero, 1b

    ret



#──────────────────────────────────────────────────────────────────────────
#──  Convertir un bcd del tamaño indicado (4,8,16,32 bits) en un
#──  array de caracteres bcd
#──
#──  Ej. n=0xCAFEBACA:  --> 0xC, 0xA, 0xF, 0xE, 0xB, 0xA, 0xC, 0xA
#──      (tamaño 32 bits)
#──
#──  Ej. n=0xCAFE (tam=16 bits) --> 0xC, 0xA, 0xF, 0xE 
#──
#──  Ej. 0x5A (tam=8 bits) --> 0x5, 0xA
#──
#──  ENTRADAS:
#──    a0: Direccion del comienzo del array
#──    a1: Numero a convertir
#──    a2: Tamaño en bits (4, 8, 16, 32)
#──────────────────────────────────────────────────────────────────────────
    .global bcd_to_bcd_array
bcd_to_bcd_array:


    #-- Numero del digito actual (7-0)
    #-- t1: Digito actual (i)
    srli t1, a2, 2  #-- Tamaño en digitos (Dividiendo entre 4)
    addi t1, t1, -1 #-- Digito de mayor peso

    #-- Mascara inicial para obtener el digito de mayor peso
    #-- t0: Mascara para digito
    #-- Se obtiene desplazando hacia la izquierda 0xF
    #-- Hay que multiplicar t1 * 4 para obtener los bits a desplazar
    slli t0, t1, 2   #-- Bits a desplazar 0xF para construir la mascara
    li t2, 0xF       #-- Valor inicial
    sll t0, t2, t0  #-- Obtener la mascara!

1:
    #-- Obtener el digito i
    and t2, a1, t0  #-- Aplicar máscara
    li t3, 2
    sll t4, t1, t3  #-- (t4 = t1 << 2) t4 = 4 * i
    srl t2, t2, t4 #-- Digito en posicion de menor peso

    #-- Almacenar digito i
    andi t2, t2, 0xF
    sb t2, 0(a0)

    #-- Siguiente digito
    addi t1, t1, -1

    #-- Apuntar al siguiente elemento del array
    addi a0, a0, 1

    #-- Actualizar mascara
    srli t0, t0, 4

    #-- Si mascara no es cero, repetir
    bne t0, zero, 1b

    #-- Terminar
    #-- a0 apunta al final del array
    ret


#-- Convertir un numero entero (decimal) de 32 bits a digitos bcd
#-- a0: Buffer
#-- a1: Numero a convertir
#--
#-- Salidas: a1, a0: numeros bcd
#--------------------------------------------------------------
 #-- Algoritmo Doubble Dabble
 #-- https://en.wikipedia.org/wiki/Double_dabble
 #--------------------------------------------------------------
 #-- Registro de calculo para hacer los desplazamientos:
 #
 #  -Parte alta
 #    31                                              8 | 7    4 | 3       0
 #  +------------------------------------------------------------------------+
 #  |                                                   |   Dig9 |   Dig8    |
 #  |                                                   | 0 0 0 0|  0 0 0 0  |
 #  +------------------------------------------------------------------------+
 #
 #  -Parte media:
 #   31   28| 27   24|23    20| 19  16 | 15   12 | 11    8| 7      4| 3     0
 #  +------------------------------------------------------------------------+
 #  |  Dig7 |  Dig6  |  Dig5  | Dig 4  |  Dig3   | Dig2   |  Dig1   |  Dig0  |
 #  |0 0 0 0| 0 0 0 0| 0 0 0 0| 0 0 0 0| 0 0 0 0 | 0 0 0 0| 0 0 0 0 | 0 0 0 0|
 #  +------------------------------------------------------------------------+
 #
 #  -Parte baja:
 #   31                                                                     0
 #  +------------------------------------------------------------------------+
 #  |      n                                                                 |
 #  |  d31 - d0                                                              |
 #  +------------------------------------------------------------------------+
 
    .text

     .global uint32_to_bcd
uint32_to_bcd:

	STACK16
	PUSH2 s0, s1

	#-- Guardar los parametros
	mv s0, a0

	#-- Inicializar registro uint_buffer
	mv a0, a1  #-- num
	jal algorithm_dd_init

    #-- DEBUG
    #li s0, 0x00200000
    #li t0, 6
    #sw t0, 0(s0)
    #j .




	#-- Desplazar el uint_buffer 3 bits a la izquierda
	jal algorithm_dd_shift1
	jal algorithm_dd_shift1
	jal algorithm_dd_shift1




	#-- Bucle principal del algoritmo
	#-- Hay que hacer un total de 32 desplazamiento
	#-- Como ya se han hecho 3, quedan 29
	#-- s1: Contador de repeticiones
	li s1, 29

 sputs_uint_loop:
	
	#-- Actualizar registro uint_buffer
	#-- Hay que sumar 3 a cada digito BCD, si es > 4
	jal algorithm_dd_step

	#-- Desplazar 1 bit a la izquierda registro uint_buffer
	#-- uint_buffer << 1
	jal algorithm_dd_shift1

	#-- Queda un paso menos por hacer del algoritmo
	#-- Decrementar contador
	addi s1, s1, -1

	#-- Repetir si contador mayor a 0
	bgt s1, zero, sputs_uint_loop

	#-- La parte alta y media del registro uint_buffer contienen los digitos
	#-- BCD del numero en decimal

    #-- Devolverlos por a1 y a0
    jal algorithm_dd_read_buffer

	POP2 s0, s1
	UNSTACK16


