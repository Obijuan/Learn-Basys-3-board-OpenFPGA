//──────────────────────────────────────────────────────
//── Pulsadores de cambio (toggle button)
//──  Su estado se muestra en los LEDs
//──  Con cada pulsacion se cambia el estado del LED
//──────────────────────────────────────────────────────
#include <peripherals.h>


int toggle_btn();
int read_buttons();
void buttons_init();

void main()
{
    //-- Estado de los pulsadores de cambio
    int btns;

    //-- Inicializar modulo de los pulsadores
    buttons_init();

    //-- Bucle infinito
    while (1) {

        //-- Leer pulsadores
        btns = toggle_btn();

        //-- Mostrar los pulsadores en los LEDs
        //-- de mayor peso
        LEDS = btns << 11;
    }
}




