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

    #---- Imprimir numeros de 4 bits
    PUTSI "--> Numeros de 4 bits\n"
    PUTSI "* Bin4: "
    PRINT_BIN4I 0xC
    PUTCHARI '\n'

    PUTSI "* Hex4: "
    PRINT_HEX4I 0xC
    PUTCHARI '\n'

    PUTSI "* Dec4: "
    PRINT_UINTI 0xC
    PUTCHARI '\n'

    PUTSI "* Dec4 (max): "
    PRINT_UINTI 0xF
    PUTCHARI '\n'

    PUTCHARI '\n'

    #---- Imprimir numeros de 8 bits
    PUTSI "--> Numeros de 8 bits\n"
    PUTSI "* Bin8: "
    PRINT_BIN8I 0x55
    PUTCHARI '\n'

    PUTSI "* Hex8: "
    PRINT_HEX8I 0x55
    PUTCHARI '\n'

    PUTSI "* Dec8: "
    PRINT_UINTI 0x55
    PUTCHARI '\n'

    PUTSI "* Dec8 (max): "
    PRINT_UINTI 0xFF
    PUTCHARI '\n'

    PUTCHARI '\n'

    #----- Imprimir numeros de 16 bits
    PUTSI "--> Numeros de 16 bits\n"
    PUTSI "* Bin16: "
    PRINT_BIN16I 0xAAAA
    PUTCHARI '\n'

    PUTSI "* Hex16: "
    PRINT_HEX16I 0xAAAA
    PUTCHARI '\n'

    PUTSI "* Dec16: "
    PRINT_UINTI 0xAAAA
    PUTCHARI '\n'

    PUTSI "* Dec16 (max): "
    PRINT_UINTI 0xFFFF
    PUTCHARI '\n'

    PUTCHARI '\n'

    #----- Imprimir numeros de 32 bits
    PUTSI "--> Numeros de 32 bits\n"
    PUTSI "* Bin32: "
    PRINT_BIN32I 0xCAFEBACA
    PUTCHARI '\n'

    PUTSI "* Hex32: "
    PRINT_HEX32I 0xCAFEBACA
    PUTCHARI '\n'

    PUTSI "* Dec32: "
    PRINT_UINTI 0xCAFEBACA
    PUTCHARI '\n'

    PUTSI "* Dec32 (max): "
    PRINT_UINTI 0xFFFFFFFF
    PUTCHARI '\n'

    halt


    .data
buff:   .space 255
buff1:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
