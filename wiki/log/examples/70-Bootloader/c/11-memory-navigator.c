//──────────────────────────────────────────────────────
//──  Memory-navigator
//──    Observar el contenido de la memoria en los
//──  displays de 7 segmentos
//──  Con las teclas UP-DOWN se cambiar la direccion actual
//── Con LEFT-RIGHT se cambia el peso de la visualizacion:
//──   * Media palabra alta
//──   * Media palabra baja 
//──────────────────────────────────────────────────────
#include <peripherals.h>
#include <disp7.h>
#include <buttons.h>

void main()
{

    uint32_t value;
    uint32_t *addr = (uint32_t *) MEMORY_ADDR;
    int show_lower = 1;
    uint8_t btns;

    while (1) {

        //-- Mostrar direccion actual en los leds
        LEDS = (uint32_t) addr;

        //-- Leer direccion actual
        value = *addr;

        //-- Mostrar el valor en el 7 segmentos
        //-- (parte alta o baja según corresponda)
        if (show_lower)
            //-- Mostrar parte baja
            disp_hex4(value & 0xFFFF);
        else
            //-- Mostrar parte alta
            disp_hex4(value >> 16);

        //-- Leer los pulsadores
        btns = read_buttons();

        //-- Boton DOWN: incrementar la direccion de memoria
        if (btns & BTN_DOWN)
            addr = addr + 1;

        //-- Boton UP: Decrementar la direccion de memoria
        if (btns & BTN_UP)
            addr = addr - 1;

        //-- Boton LEFT: Mostrar la parte alta
        if (btns & BTN_LEFT)
            show_lower = 0;

        //-- Boton RIGHT: Mostrar parte baja
        if (btns & BTN_RIGHT)
            show_lower = 1;
    }
}
