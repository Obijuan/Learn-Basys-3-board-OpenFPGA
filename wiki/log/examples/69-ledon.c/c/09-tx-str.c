//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

//-- Otras bibliotecas
#include <delay.h>
#include <uart.h>

//-- Pausa para la secuencia
#define PAUSA _500ms



__attribute__((naked))
void __reset() {
    
    //-- Inicializar la pila
    asm("la sp, __ram_end");

    __transmit_string("Ejemplo 09-tx-str.c\n");
    __transmit_string("-------------------\n");

    //-- Secuencia infinita
    while (1) {

        //-- Mostrar valor en LEDs
        LEDS = 0xF00F;
        __transmit_char('*');

        delay(PAUSA);

        //-- Valor 2 LEDs
        LEDS = 0x0FF0;
        __transmit_char('-');

        delay(PAUSA);
    }
}



//-- Dependencias
#include <delay.c>
#include <uart.c>

