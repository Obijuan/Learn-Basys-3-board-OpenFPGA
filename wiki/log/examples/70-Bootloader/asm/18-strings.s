    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"
    .include "uart.h"

    .text

       .global __reset
__reset:

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Poner patron inicial en los leds
    li t0, 0xF00F
    sw t0, 0(s0)

    #--- Borrar pantalla
    ANSI_HOME
    ANSI_CLS

    #-- Convertir numero binario4 a bcd
    la a0, buff
    li a1, 0xA
    jal bin4_to_bcd_array

    #-- Convertir a cadena
    la a0, buff
    li a1, 4
    jal bcd_array_to_string

    #-- Imprimir
    la a0, buff
    jal puts

    PUTCHARI '\n'

    halt


#-- Convertir un numero binario de 4 bits a un array
#-- de caracteres bcd
#-- a0: Direccion del comienzo del array
#-- a1: Numero a convertir
bin4_to_bcd_array:

    #-- t0: Mascara del bit actual
    li t0, 0x8

    #-- t1: Nº de bit (el de mayor peso)
    li t1, 3

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



    .data
buff:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
