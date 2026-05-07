
//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

__attribute__((naked))
void __reset() {
    
    //-- Guardar el valor 0xFF en la dirección 0x00200000
    *(uint16_t*)0x00200000 = 0xFF;
    
    while(1);
}

