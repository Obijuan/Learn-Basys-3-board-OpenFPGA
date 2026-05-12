//──────────────────────────────────────────────────────
//──    BIBLIOTECA PARA LA UART
//──  Funciones de bajo nivel
//──────────────────────────────────────────────────────
#include "peripherals.h"


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


