//──────────────────────────────────────────────────────
//──    Encender el LED 0
//──────────────────────────────────────────────────────
#include <peripherals.h>

int main() {
    
    //-- Encender el LED 0
    LEDS = LED0;

    //-- La biblioteca crt se encarga de "parar"
    //-- el procesador. No hay que poner aqui nada
}

