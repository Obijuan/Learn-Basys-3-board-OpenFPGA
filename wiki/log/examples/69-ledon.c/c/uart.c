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

//------------------------------------------
//-- Recibir un caracter por el puerto serie
//-- Se devuelve -1 en caso de error
//--------------------------------------------
int __receive_byte() {
    while (1) {
        if (UART_RX_STATUS & UART_RX_STATUS_FULL_MASK) {
            return UART_BUFFER;
        }

        if (UART_RX_STATUS & UART_RX_STATUS_ER_MASK ) {
            __transmit_string("ERROR: Error while receiving UART byte\n");
            return -1;
        }
    }
}
