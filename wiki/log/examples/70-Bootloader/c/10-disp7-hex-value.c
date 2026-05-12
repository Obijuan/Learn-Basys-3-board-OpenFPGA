//──────────────────────────────────────────────────────
//──  Mostrar un numero hexadecimal en 
//──  el display de 7 segmentos
//──  Con la tecla UP se incrementa
//──────────────────────────────────────────────────────
#include <peripherals.h>
#include <disp7.h>
#include <buttons.h>

//-- Numero a mostrar en el display
#define NUMERO 0xCAFE

void main() 
{
    //-- Apagar los LEDS
    LEDS = 0;

    int num = NUMERO;
    uint8_t btns;

    //-- Bucle principal
    while (1) {

        //-- Mostrar numero en el display
        //SEGMENTS = bcd2disp(0x0);
        disp_hex4(num);

        //-- Leer los pulsadores
        btns = read_buttons();

        //-- Boton UP: incrementar el numero
        if (btns & BTN_UP) {
            num = num + 1;
        }

        //-- boton DOWN: decrementar el numero
        if (btns & BTN_DOWN) {
            num = num - 1;
        }
    }
}

