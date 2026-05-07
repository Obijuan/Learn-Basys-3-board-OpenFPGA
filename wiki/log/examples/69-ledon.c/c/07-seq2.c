
//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

//-- Constantes para el delay
//-- hex(int(0.250 * 25_000_000 / 7))
#define _50ms 0x2b98b
#define _100ms _50ms * 2
#define _200ms _100ms * 2
#define _250ms _200ms + _50ms
#define _500ms _250ms * 2
#define _1s _500ms * 2

#define PAUSA _500ms

void test(uint32_t val);


__attribute__((naked))
void __reset() {
    
    //-- Inicializar la pila
    asm("la sp, __ram_end");

    //-- Secuencia infinita
    while (1) {

        //-- Mostrar valor en LEDs
        test(0xAAAA);

        //-- Pausa
        for (uint32_t i=0; i<PAUSA; i++) {
            asm("nop");
        }

        //-- Valor 2 LEDs
        LEDS = 0x5555;

        //-- Pausa
        for (uint32_t i=0; i<PAUSA; i++) {
            asm("nop");
        }
    }
}

void test(uint32_t val)
{
    LEDS = val;
}