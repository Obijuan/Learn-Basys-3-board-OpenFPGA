//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

//-- Otras bibliotecas
#include <uart.h>

__attribute__((naked))
void __reset() {
    
    //-- Inicializar la pila
    asm("la sp, __ram_end");

    __transmit_string("Ejemplo 11-rx-hex-byte\n");
    __transmit_string("======================\n");
    __transmit_string("Introduce bytes en hexa: \n");

    //-- Mostrar valor en LEDs
    LEDS = 0xAAAA;

    uint8_t byte;

    //-- Secuencia infinita
    while (1) {

        //-- Leer un caracter hexa
        byte = __receive_hex_byte();

        //-- Mostrarlo en los leds
        LEDS = byte;
    }
}


//-- Dependencias
#include <delay.c>
#include <uart.c>

