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


    #-- Imprimir numero en binario en el buffer
    la a0, buff
    li a1, 0x1
    li a2, 8
    li a3, 0     #-- sin Eliminar ceros iniciales
    jal sprint_bin

    #-- Imprimir el buffer
    la a0, buff
    jal puts

    PUTCHARI '\n'


    #-- Imprimir numero en binario en el buffer
    la a0, buff
    li a1, 0x1
    li a2, 8
    li a3, 1     #-- Eliminar ceros iniciales
    jal sprint_bin

    #-- Imprimir el buffer
    la a0, buff
    jal puts

    PUTCHARI '\n'

    halt


    .data
buff:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
