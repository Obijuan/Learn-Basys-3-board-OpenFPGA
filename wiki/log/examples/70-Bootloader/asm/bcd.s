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
