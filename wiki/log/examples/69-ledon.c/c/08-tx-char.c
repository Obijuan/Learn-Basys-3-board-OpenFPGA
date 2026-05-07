//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

//-- Otras bibliotecas
#include <delay.h>

//-- Prototipos
void __transmit_char(char c);

//-- Pausa para la secuencia
#define PAUSA _500ms



__attribute__((naked))
void __reset() {
    
    //-- Inicializar la pila
    asm("la sp, __ram_end");

    //-- Secuencia infinita
    while (1) {

        //-- Mostrar valor en LEDs
        LEDS = 0xAAAA;
        __transmit_char('A');

        delay(PAUSA);

        //-- Valor 2 LEDs
        LEDS = 0x5555;
        __transmit_char('B');

        delay(PAUSA);
    }
}

void __transmit_char(char c) {
    while (! (*UART_TX_STATUS_ADDRESS & (1 << UART_TX_STATUS_IDX_EMPTY)));

    *UART_BUFFER_ADDRESS = c;
}

//-- Dependencias
#include <delay.c>

