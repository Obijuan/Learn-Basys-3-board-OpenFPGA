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
        LEDS = 0xAA55;
        __transmit_char('A');

        delay(PAUSA);

        //-- Valor 2 LEDs
        LEDS = 0x55AA;
        __transmit_char('B');

        delay(PAUSA);
    }
}

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

//-- Dependencias
#include <delay.c>

