
//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- PERIFERICO: LEDS
#define LEDS_ADDR  ((volatile uint16_t*)0x00200000)
#define LEDS       *LEDS_ADDR

__attribute__((naked))
void __reset() {
    
    //-- Mostrar valor en LEDs
    LEDS = 0xAAAA;
    
    while(1);
}

