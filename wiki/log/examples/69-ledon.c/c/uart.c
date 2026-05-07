#include <peripherals.h>
#include <stdint.h>

//---------------------------------------------------
//-- Transmitir un caracter por el puerto serie 
//---------------------------------------------------
void __transmit_char(char c) {

    //-- Esperar mientras el bit esté a 0
    while (! (UART_TX_STATUS & UART_TX_STATUS_EMPTY_MASK));

    //-- Bit se pone a 1: Listo para transmitir
    //-- Transmitir!
    UART_BUFFER = c;
}

//----------------------------------------------
//-- Transmitir una cadena por el puerto serie
//----------------------------------------------
void __transmit_string(char *val) {
    while (*val) {
        __transmit_char(*val);
        val++;
    }
}

