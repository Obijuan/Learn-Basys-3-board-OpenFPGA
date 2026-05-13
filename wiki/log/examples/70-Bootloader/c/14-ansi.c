//──────────────────────────────────────────────────────
//──  Imprimir mensajes en diferentes colores
//──────────────────────────────────────────────────────
#include "peripherals.h"
#include "uart.h"


#define ANSI_HOME  "\033[H"
#define ANSI_CLS   "\033[2J" 
#define ANSI_GREEN "\033[0;32m"
#define ANSI_BLUE  "\033[0;34m"
#define ANSI_RED   "\033[0;31m"
#define ANSI_RESET "\033[0m"


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



