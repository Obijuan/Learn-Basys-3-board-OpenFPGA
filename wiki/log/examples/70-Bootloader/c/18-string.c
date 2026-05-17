#include "peripherals.h"
#include "uart.h"
#include "ansi.h"
#include "stdio.h"
#include "bcd.h"

void main()
{
    //-- Mostrar patron inicial en los leds
    LEDS = 0xF00F;

    //-- Borrar la pantalla
    _puts(ANSI_RESET);
    _puts(ANSI_HOME);
    _puts(ANSI_CLS);

    //---- Imprimir numeros de 4 bits
    _puts("--> Numeros de 4 bits\n");
    _puts("* Bin4: ");
    print_bin(0xC, 4);
    _putchar('\n');

    _puts("* Hex4: ");
    print_hex(0xC, 4);
    _putchar('\n');
}


    // PUTSI "* Dec4: "
    // PRINT_UINTI 0xC
    // PUTCHARI '\n'

    // PUTSI "* Dec4 (max): "
    // PRINT_UINTI 0xF
    // PUTCHARI '\n'

    // PUTCHARI '\n'

    // #---- Imprimir numeros de 8 bits
    // PUTSI "--> Numeros de 8 bits\n"
    // PUTSI "* Bin8: "
    // PRINT_BIN8I 0x55
    // PUTCHARI '\n'

    // PUTSI "* Hex8: "
    // PRINT_HEX8I 0x55
    // PUTCHARI '\n'

    // PUTSI "* Dec8: "
    // PRINT_UINTI 0x55
    // PUTCHARI '\n'

    // PUTSI "* Dec8 (max): "
    // PRINT_UINTI 0xFF
    // PUTCHARI '\n'

    // PUTCHARI '\n'

    // #----- Imprimir numeros de 16 bits
    // PUTSI "--> Numeros de 16 bits\n"
    // PUTSI "* Bin16: "
    // PRINT_BIN16I 0xAAAA
    // PUTCHARI '\n'

    // PUTSI "* Hex16: "
    // PRINT_HEX16I 0xAAAA
    // PUTCHARI '\n'

    // PUTSI "* Dec16: "
    // PRINT_UINTI 0xAAAA
    // PUTCHARI '\n'

    // PUTSI "* Dec16 (max): "
    // PRINT_UINTI 0xFFFF
    // PUTCHARI '\n'

    // PUTCHARI '\n'

    // #----- Imprimir numeros de 32 bits
    // PUTSI "--> Numeros de 32 bits\n"
    // PUTSI "* Bin32: "
    // PRINT_BIN32I 0xCAFEBACA
    // PUTCHARI '\n'

    // PUTSI "* Hex32: "
    // PRINT_HEX32I 0xCAFEBACA
    // PUTCHARI '\n'

    // PUTSI "* Dec32: "
    // PRINT_UINTI 0xCAFEBACA
    // PUTCHARI '\n'

    // PUTSI "* Dec32 (max): "
    // PRINT_UINTI 0xFFFFFFFF
    // PUTCHARI '\n'

    // halt





