//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

//-- Otras bibliotecas
#include <delay.h>
#include <uart.h>

//-- Pausa para la secuencia
#define PAUSA _500ms

int __receive_byte();

__attribute__((naked))
void __reset() {
    
    //-- Inicializar la pila
    asm("la sp, __ram_end");

    __transmit_string("Ejemplo 10-rx-char.c\n");
    __transmit_string("====================\n");

    //-- Mostrar valor en LEDs
        LEDS = 0xAAAA;

    uint8_t car;

    //-- Secuencia infinita
    while (1) {

        //-- Esperar a recibir un caracter
        car = __receive_byte();

        //-- Mostrarlo en los leds
        LEDS = car;

        //-- Hacer eco
        __transmit_char(car);
    }
}


//-- Dependencias
#include <delay.c>
#include <uart.c>

