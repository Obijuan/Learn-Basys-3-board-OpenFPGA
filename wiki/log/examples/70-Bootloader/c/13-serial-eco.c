//──────────────────────────────────────────────────────
//──  Hacer ECO de todo lo recibido por el puerto serie
//──────────────────────────────────────────────────────
#include "peripherals.h"
#include "uart.h"
#include "disp7.h"

void main() 
{

    char car;

    //-- Poner patron inicial en los leds
    LEDS = 0xF00F;

    while (1) {

        //-- Esperar a recibir un caracter
        car = _getchar();

        //-- Sacar el caracter por los leds
        LEDS = car;

        //-- Sacar codigo ascii por el display de 7 seg
        disp_hex4(car);

        //-- Hacer eco
        _putchar(car);
    }
}



