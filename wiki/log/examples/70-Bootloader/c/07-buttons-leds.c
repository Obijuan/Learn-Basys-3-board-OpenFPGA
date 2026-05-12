//──────────────────────────────────────────────────────
//──  Mostrar el estado de los pulsadores en los LEDs
//──────────────────────────────────────────────────────
#include <peripherals.h>


void main()
{

    //-- Bucle infinito
    while (1) {

        //-- Mostrar los LEDs en los LEDs de
        //-- mayor peso
        LEDS = BUTTONS << 11;
    }

}

