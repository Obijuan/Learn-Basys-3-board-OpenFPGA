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

    PUTSI "* Bin8: "
    PRINT_BIN8I 0x55
    PUTCHARI '\n'

    PUTSI "* Hex8: "
    PRINT_HEX8I 0x55
    PUTCHARI '\n'

    #PUTSI "* Dec8: "
    #PRINT_UINT8I 0x85
    #PUTCHARI '\n'

    la a0, buff
    li a1, 85
    li a2, 8
    li a3, 1
    jal sprint_uint

    la a0, buff
    jal puts
    PUTCHARI '\n'


    #-- Convertir numero decimal a digitos bcd
    li a0, 85
    jal uint32_to_bcd


    #-- a1 y a0 tienen los digitos bcd
    mv t0, a0
    mv t1, a1

    #-- Convertir a array de digitos bcd
    la a0, buff
    mv a1, t0
    jal bcd_to_bcd_array
    
    #-- Convertir a cadena
    la a0, buff
    li a1, 8
    jal bcd_array_to_string

    #-- Eliminar 0s iniciales
    la a0, buff
    jal str_remove_leading_zeros

    #-- Imprimir!
    jal puts

    PUTCHARI '\n'

    halt


    .data
buff1:  .space 255
buff:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
