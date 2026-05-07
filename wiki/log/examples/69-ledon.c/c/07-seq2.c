//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

//-- Otras bibliotecas
#include <delay.h>

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

        delay(PAUSA);

        //-- Valor 2 LEDs
        LEDS = 0x5555;

        delay(PAUSA);
    }
}

//-- Dependencias
#include <delay.c>

