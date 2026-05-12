//──────────────────────────────────────────────────────
//──  Mostrar los switches en los LEDs y en el display
//──  de 7 segmentos
//──────────────────────────────────────────────────────
#include "peripherals.h"
#include "disp7.h"


int main()
{
    int switches;

    //-- Bucle principal
    while (1) {
        //-- Leer los switches
        switches = SWITCHES;

        //-- Mostrar los switches en los leds
        LEDS = switches;

        //-- MOstrar el numero en el display de 7 segmentos
        disp_hex4(switches);
    }

}