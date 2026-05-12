//──────────────────────────────────────────────────────
//──    Sacar un valor de 16 bits por los LEDs
//──────────────────────────────────────────────────────
#include <peripherals.h>

#define VALOR 0xF00F

int main() {
    
    //-- Sacar un valor por los LEDs
    LEDS = VALOR;
}

