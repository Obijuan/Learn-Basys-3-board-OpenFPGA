//──────────────────────────────────────────────────────
//──    Encender el LED 0
//──────────────────────────────────────────────────────
#include <peripherals.h>

//-- Valor a mostrar en los LEDs
#define VALOR 0xF00F

int main() {
    
    //-- Mostrar valor en LEDs
    LEDS = VALOR;

    //-- La biblioteca crt se encarga de "parar"
    //-- el procesador. No hay que poner aqui nada
}

