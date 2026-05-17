#include "peripherals.h"
#include "uart.h"
#include "ansi.h"
#include "stdio.h"

void print_bin(int num_bin, int size);


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
}

//──────────────────────────────────────────────────────
//──  Imprimir un numero en binario
//──
//──  ENTRADAS:
//──    * num_bin: Numero a imprimir en binario
//──    * size: Tamaño del Numero en bits (digitos) 
//──────────────────────────────────────────────────────
void print_bin(int num_bin, int size)
{
    char buffer[33];
    int bit;

    //-- Recorrer el buffer
    for (int i=0; i<size; i++) {

        //-- Bit actual del numero
        bit = (size-1)-i;

        //-- Convertir el bit actual a caracter
        buffer[i] = (num_bin & (1 << bit)) ? '1' : '0';  
    }

    //-- Fin de la cadena
    buffer[size] = 0;

    //-- Imprimir el buffer
    _puts(buffer);
}


// #──────────────────────────────────────────────────────
// #──  Convertir un numero binario de n bits a un array
// #──  de caracteres bcd
// #──
// #──  Ej. n=3: 110 --> 0001, 0001, 0000
// #── 
// #──  ENTRADAS:
// #──    a0: Direccion del comienzo del array
// #──    a1: Numero a convertir
// #──    a2: Tamaño en bits
// #──────────────────────────────────────────────────────
//     .global bin_to_bcd_array
// bin_to_bcd_array:

//     #-- t1: Nº de bit (el de mayor peso)
//     addi t1, a2, -1

//     #-- t0: Mascara del bit actual
//     li t2, 1
//     sll t0, t2, t1  #-- 1 << t1

// 1:
//     #-- Obtener bit i-simo
//     and t2, a1, t0   #-- t2 = n & mask
//     srl t2, t2, t1   #-- t2 >> i

//     #-- Almacenar bit i
//     andi t2, t2, 1   #-- Eliminar todo menos el bit 0
//     sb t2, 0(a0)

//     #-- Apuntar al siguiente elemento del array
//     addi a0, a0, 1

//     #-- Siguiente mascara
//     srli t0, t0, 1   #-- mask >> 1

//     #-- Siguiente bit
//     addi t1, t1, -1

//     #-- Si mascara es 0, hemos terminado
//     bne t0, zero, 1b

//     ret



// #---------------------------------------------------
// #-- Imprimir numero binario de 4 bit en consola
// #---------------------------------------------------
// .macro PRINT_BIN4I num:req
//     li a0, \num
//     li a1, 4
//     li a2, 0  #-- Mostrar 0s iniciales
//     jal print_bin
// .endm

// #──────────────────────────────────────────────────────
// #──  Imprimir un numero en binario, de 4 bits
// #──  En un buffer de memoria
// #──
// #──  ENTRADAS:
// #──    a0: Buffer donde imprimir
// #──    a1: Numero a imprimir en binario
// #──    a2: Tamaño del numero binario (en bits)
// #──    a3: Eliminar 0s iniciales (0=No, 1=si)
// #── 
// #──  SALIDAS:
// #──    a0: Direccion donde comienza la cadena
// #──────────────────────────────────────────────────────
//   .global sprint_bin
// sprint_bin:
//     STACK16

//     #-- Guardar los parametros
//     sw a0, 0(sp)  #-- Buffer
//     sw a2, 4(sp)  #-- Tamaño del numero
//     sw a3, 8(sp)  #-- Espacios iniciales

//     #-- Convertir a array bcd
//     #-- Guardarlo en un buffer interno
//     la a0, __buff
//     jal bin_to_bcd_array

//     #-- Convertir a cadena
//     la a0, __buff
//     lw a1, 4(sp)  #-- Tamaño
//     jal bcd_array_to_string

//     #-- Comprobar si hay que eliminar ceros iniciales o no
//     lw a3, 8(sp)
//     beq a3, zero, no_remove_ceros

//     #-- Hay que eliminar los 0s
//     la a0, __buff
//     jal str_remove_leading_zeros

//     #-- a0: cadena sin ceros
//     j cont
    
// no_remove_ceros:
//     #-- Seleccionar cadena desde el principio
//     la a0, __buff

// cont:

//     #-- Copiar el numero-cadena en el buffer de la cadena
//     #-- La cadena origen a0 contiene bien el numero completo
//     #-- o bien apunta al numero sin 0s iniciales
//     lw a1, 0(sp)  #-- buffer destino
//     jal strcpy

//     UNSTACK16





    // PUTSI "* Hex4: "
    // PRINT_HEX4I 0xC
    // PUTCHARI '\n'

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





