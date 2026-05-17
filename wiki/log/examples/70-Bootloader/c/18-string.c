#include "peripherals.h"
#include "uart.h"
#include "ansi.h"
#include "stdio.h"
#include "bcd.h"

void print_uint(uint32_t num, int size);
void algorithm_dd_shift1();

void main()
{
    //-- Mostrar patron inicial en los leds
    LEDS = 0xF00F;

    //-- Borrar la pantalla
    _puts(ANSI_RESET);
    _puts(ANSI_HOME);
    _puts(ANSI_CLS);


    print_hex(0x60000000, 32);
    _putchar('\n');
    print_hex(0x80000000, 32);
    _putchar('\n');
    print_hex(0xC0000000, 32);
    _putchar('\n');


    //---- Imprimir numeros de 4 bits
    _puts("--> Numeros de 4 bits\n");
    _puts("* Bin4: ");
    print_bin(0xC, 4);
    _putchar('\n');

    _puts("* Hex4: ");
    print_hex(0xC, 4);
    _putchar('\n');

    _puts("* Dec4: ");
    print_uint(10, 4);
    _putchar('\n');
}

//-- Buffer para usar con el algoritmo double_dabble
//-- buffer[2]: parte alta
//-- buffer[1]: parte media
//-- buffer[0]: Parte baja: Numero a convertir
uint32_t buffer[3];

//-- Desplazar el buffer un bit a la izquierda
void algorithm_dd_shift1()
{
    //-- Desplazar el buffer 1 bit a la izquierda
    buffer[0] = buffer[0] << 1;
    buffer[0] = buffer[0] | (buffer[1] >> 31);

    buffer[1] = buffer[1] << 1;
    buffer[1] = buffer[1] | (buffer[2] >> 31);

    buffer[2] = buffer[2] << 1;
}


//-- Aplicar un paso del algoritmo al numero
uint32_t algorithm_dd_step(uint32_t num)
{
    int bcd;
    int pos;
    uint32_t mask;

    //-- Recorrer los 8 digitos bcd
    for (int i=7; i>=0; i--) {

        //-- Posicion del digito (en bits)
        pos = i << 2;  //(i * 4)

        //-- Mascara para seleccionar el digito actual
        mask = 0xFF << pos;

        //-- Obtener digito bcd actual
        bcd = (num & mask) >> pos;

        //-- Actualizar digito
        //-- Si dig > 4, dig = dig + 3
        if (bcd > 4)
            bcd = bcd + 3;

        //-- Colocar digito en su posicion
        num = (num & ~mask) | (bcd << pos);
    }

    //-- Devolver el nuevo valor
    return num;
}

//-- Convertir un numero entero de 32bits a sus 10 digitos bcd
uint64_t uint_to_bcd(uint32_t num)
{
    //-- Inicializar el buffer
    buffer[0] = 0;
    buffer[1] = 0;
    buffer[2] = num;

    //-- DEBUG
    _puts("\n");
    print_hex(buffer[0], 32);
    print_hex(buffer[1], 32);
    print_hex(buffer[2], 32);
    _puts("\n");

    //-- Desplazar el buffer 3 bits a la izquierda
    for (int i=0; i<3; i++) {
        algorithm_dd_shift1();

        //-- DEBUG
        print_hex(buffer[0], 32);
        print_hex(buffer[1], 32);
        print_hex(buffer[2], 32);
        _puts("\n");
    }

    //-- DEBUG
    _puts("-----\n");

    //-- Bucle principal del algoritmo
    for (int i=0; i<29; i++) {
        //-- Actualizar registro buffer
	    //-- Hay que sumar 3 a cada digito BCD, si es > 4
	    buffer[0] = algorithm_dd_step(buffer[0]);
        buffer[1] = algorithm_dd_step(buffer[1]);

	    //-- Desplazar 1 bit a la izquierda registro buffer
	    //-- buffer << 1
        algorithm_dd_shift1();

        //-- DEBUG
        print_hex(buffer[0], 32);
        print_hex(buffer[1], 32);
        print_hex(buffer[2], 32);
        _puts("\n");
    }


    //-- DEBUG!!!!!
    //print_hex(buffer[1], 8);
    //_puts("\n");


    //-- Buffer[0] contiene 2 digitos bcd
    //-- Buffer[1] contiene 8 digitos bcd
    return (uint64_t)buffer[0]<<32 | buffer[1];
}

void print_uint(uint32_t num, int size)
{
    uint64_t num_bcd;

    //-- 1º: Convertir numero a digitos BCD
    num_bcd = uint_to_bcd(num);

    //print_hex(num_bcd, 8);

}
    

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





