    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"
    .include "uart.h"
    .include "stack.h"

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

    #-- Convertir numero array bcd
    la a0, buff
    li a1, 0xCAFEBACA
    jal bcd32_to_bcd_array
    
    #-- Convertir a cadena
    la a0, buff
    li a1, 8
    jal bcd_array_to_string

    #-- Imprimir!
    la a0, buff
    jal puts

    PUTCHARI '\n'

    halt


    .data
buff:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
