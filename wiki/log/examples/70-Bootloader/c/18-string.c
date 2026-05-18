#include <stdbool.h>
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

    print_uint(0);
    _puts("\n");

    //---- Imprimir numeros de 4 bits
    _puts("--> Numeros de 4 bits\n");
    _puts("* Bin4: ");
    print_bin(0xC, 4);
    _putchar('\n');

    _puts("* Hex4: ");
    print_hex(0xC, 4, true);
    _putchar('\n');

    _puts("* Dec4: ");
    print_uint(0xC);
    _putchar('\n');

    _puts("* Dec4 (max): ");
    print_uint(0xF);
    _putchar('\n');
    _putchar('\n');

    //---- Imprimir numeros de 8 bits
    _puts("--> Numeros de 8 bits\n");
    _puts("* Bin8: ");
    print_bin(0x55, 8);
    _putchar('\n');

    _puts("* Hex8: ");
    print_hex(0x55, 8, true);
    _putchar('\n');

    _puts("* Dec8: ");
    print_uint(0x55);
    _putchar('\n');

    _puts("* Dec8 (max): ");
    print_uint(0xFF);
    _putchar('\n');
    _putchar('\n');

    //----- Imprimir numeros de 16 bits
    _puts("--> Numeros de 16 bits\n");
    _puts("* Bin16: ");
    print_bin(0xAAAA, 16);
    _putchar('\n');

    _puts("* Hex16: ");
    print_hex(0xAAAA, 16, true);
    _putchar('\n');

    _puts("* Dec16: ");
    print_uint(0xAAAA);
    _putchar('\n');

    _puts("* Dec16 (max): ");
    print_uint(0xFFFF);
    _putchar('\n');
    _putchar('\n');

    //----- Imprimir numeros de 32 bits
    _puts("--> Numeros de 32 bits\n");
    _puts("* Bin32: ");
    print_bin(0xCAFEBACA, 32);
    _putchar('\n');

    _puts("* Hex32: ");
    print_hex(0xCAFEBACA, 32, true);
    _putchar('\n');

    _puts("* Dec32: ");
    print_uint(0xCAFEBACA);
    _putchar('\n');

    _puts("* Dec32 (max): ");
    print_uint(0xFFFFFFFF);
    _putchar('\n');
    _putchar('\n');

}




    


