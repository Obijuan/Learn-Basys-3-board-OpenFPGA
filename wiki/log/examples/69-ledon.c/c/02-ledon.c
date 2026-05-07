
//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Definir el puntero a los leds. Es de 16 bits porque
//-- hay 16 leds
uint16_t *led;

__attribute__((naked))
void __reset() {
    
    //-- Asignar la direccion de los LEDs al puntero
    //-- Es obligatorio usar un cast
    led = (uint16_t *) 0x00200000;

    //-- Mostrar un valor en los leds
    *led = 0xAA;
    
    while(1);
}

