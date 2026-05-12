//──────────────────────────────────────────────────────
//──  LED parpadeante
//──────────────────────────────────────────────────────
#include <peripherals.h>
#include <delay.h>

//-- LED que se quiere parpadear
#define LED LED15

//-- Pausa entre valores
#define PAUSA _500ms

void main()
{
    //-- Estado del led
    int led = LED;

    //-- Bucle infinito
    while (1) {

        //-- Encender el LED
        LEDS = led;

        //-- Esperar
        delay(PAUSA);

        //-- Cambiar de estado el valor
        led = led ^ LED;

    }
}

