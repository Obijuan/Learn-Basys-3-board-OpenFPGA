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

    #-- DEBUG
    #li s0, 0x00200000
    #sw t0, 0(s0)
    #j .


    la a0, buff
    li a1, 12
    li a2, 4
    li a3, 1
    jal sprint_uint
    #jal sprint_hex

    la a0, buff
    jal puts


    #---- Imprimir numeros de 4 bits
    # PUTSI "--> Numeros de 4 bits\n"
    # PUTSI "* Bin4: "
    # PRINT_BIN4I 0xC
    # PUTCHARI '\n'

    # PUTSI "* Hex4: "
    # PRINT_HEX4I 0xC
    # PUTCHARI '\n'

    # PUTSI "* Dec4: "
    # PRINT_UINT4I 0xC
    # PUTCHARI '\n'

    # PUTCHARI '\n'

    # #---- Imprimir numeros de 8 bits
    # PUTSI "--> Numeros de 8 bits\n"
    # PUTSI "* Bin8: "
    # PRINT_BIN8I 0x55
    # PUTCHARI '\n'

    # PUTSI "* Hex8: "
    # PRINT_HEX8I 0x55
    # PUTCHARI '\n'

    # PUTSI "* Dec8: "
    # PRINT_UINT8I 0x55
    # PUTCHARI '\n'

    #----- Imprimir numeros de 16 bits


    halt


    .data
buff1:  .space 255
buff:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
