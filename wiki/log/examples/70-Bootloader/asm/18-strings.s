    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"

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

    #-- Imprimir
    la a0, src
    jal puts

    #-- Eliminar zeros
    la a0, src
    jal str_remove_leading_zeros

    mv s0, a0

    #-- a0 contiene la cadena sin los 0s iniciales
    jal puts

    #-- Copiar la cadena
    mv a0, s0
    la a1, dst
    jal strcpy

    #-- Imprimir cadena copiada
    la a0, dst
    jal puts

    halt




    .data
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
