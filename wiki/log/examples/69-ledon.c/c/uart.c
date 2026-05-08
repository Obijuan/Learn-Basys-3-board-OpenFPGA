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

//---------------------------------------------
//-- Recibir un caracter hexadecimal 
//-- '0'-'9' --> 'A' - 'F'
//-- Se devuelve -1 en caso de error
//---------------------------------------------
char __receive_hex_char() {
    char val = __receive_byte();

    if (val >= '0' && val <= '9') {
        return val - '0';
    }
    else if (val >= 'A' && val <= 'F') {
        return val - 'A' + 10;
    }
    else {
        __transmit_string("ERROR: Invalid hex character\n");
        return -1;
    }
}

//-----------------------------------------------------------
//-- Recibir un byte formado por dos caracteres ascii hexa
//-- Se devuelve -1 en caso de error
//-----------------------------------------------------------
int __receive_hex_byte() {
    char upper = __receive_hex_char();
    if (upper < 0) {
        return -1;
    }

    char lower = __receive_hex_char();
    if (lower < 0) return - 1;

    return (upper << 4) | lower;
}