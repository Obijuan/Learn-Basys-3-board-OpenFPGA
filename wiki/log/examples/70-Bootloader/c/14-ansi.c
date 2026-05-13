//──────────────────────────────────────────────────────
//──  Imprimir mensajes en diferentes colores
//──────────────────────────────────────────────────────
#include "peripherals.h"
#include "uart.h"
#include "ansi.h"




int main()
{
    //-- Poner un patrón en los LEDs
    LEDS = 0xF00F;

    //-- Borrar la pantalla
    _puts(ANSI_HOME);
    _puts(ANSI_CLS);

    //-- Imprimir mensaje
    _puts("----------------------------\n");
    _puts("Probando secuencias ansi \n");
    _puts("----------------------------\n");

    _puts(ANSI_GREEN);
    _puts("Esto es color verde...\n");

    _puts(ANSI_BLUE);
    _puts("Esto es color azul...\n");

    _puts(ANSI_RED);
    _puts("Esto es color rojo...\n");

    _puts(ANSI_RESET);
    _puts("Color reseteado...\n");

}



