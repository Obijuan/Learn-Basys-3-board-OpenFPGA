
//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

__attribute__((naked))
void __reset() {
    
    //-- Secuencia infinita
    while (1) {
        //-- Mostrar valor 1 en LEDs
        LEDS = 0xFF00;

        //-- Pausa
        for (uint32_t i=0; i<0x400000; i++) {
            asm("nop");
        }

        //-- Valor 2 LEDs
        LEDS = 0x00FF;

        //-- Pausa
        for (uint32_t i=0; i<0x400000; i++) {
            asm("nop");
        }
    }
}

