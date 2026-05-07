
//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

__attribute__((naked))
void __reset() {
    
    //-- Mostrar valor en LEDs
    LEDS = 0xFF00;

    //-- Pausa
    for (uint32_t i=0; i<0x400000; i++) {
        asm("nop");
    }

    //-- Nuevo valor en LEDs
    LEDS = 0x00FF;
    
    while(1);
}

