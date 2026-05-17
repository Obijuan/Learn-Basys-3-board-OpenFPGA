//──────────────────────────────────────────────────────
//──    BIBLIOTECA PARA LA UART
//──  Funciones de bajo nivel
//──────────────────────────────────────────────────────
#include "peripherals.h"
#include "bcd.h"


//──────────────────────────────────────────────────────
//──  Enviar un caracter por el puerto serie
//──────────────────────────────────────────────────────
void _putchar(char car)
{
    //-- Esperar hasta que se active el bit de transmisor vacio
    while (!(UART_TX_STATUS & UART_TX_STATUS_EMPTY_MASK));

    //-- Enviar caracter!
    UART_BUFFER = car;
}


//──────────────────────────────────────────────────────
//──  Recibir un caracter por el puerto serie
//──  Funcion bloqueante
//──────────────────────────────────────────────────────
char _getchar()
{
    //-- Esperar hasta que se reciba un caracter
    while (!(UART_RX_STATUS & UART_RX_STATUS_FULL_MASK));

    //-- Devolver caracter
    return UART_BUFFER;
}

//──────────────────────────────────────────────────────
//──  Enviar una cadena
//──────────────────────────────────────────────────────
void _puts(const char *s)
{
    while (*s) {
        _putchar(*s);
        s++;
    }
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

//──────────────────────────────────────────────────────
//──  Imprimir un numero en hexadecimal
//──
//──  ENTRADAS:
//──    * num_hex: Numero a imprimir en hexadecimal
//──    * size: Tamaño del Numero en bits (32, 16, 8, 4) 
//──────────────────────────────────────────────────────
void print_hex(int num_hex, int size)
{
    char buffer[9];
    int ndig;
    int size_dig;  //-- Tamaño en digitos
    int dig;
    int shift;

    //-- Obtener el tamaño en digitos
    size_dig = size >> 2;

    //-- Recorrer el buffer
    for (int i=0; i < size_dig; i++) {

        //-- Numero de Digito actual del numero
        ndig = (size_dig-1)-i;

        //-- Bits a desplazar para obtener el digito actual
        shift = ndig << 2;  // ndig*4

        //-- Obtener el digito actual en binario
        dig = (num_hex & (0xF << shift)) >> shift;

        //-- Convertir el digito actual a caracter
        //-- y almacenarlo
        buffer[i] = bcd_to_ascii(dig);
    }

    //-- Fin de la cadena
    buffer[size_dig] = 0;

    //-- Imprimir el buffer
    _puts(buffer);
}

