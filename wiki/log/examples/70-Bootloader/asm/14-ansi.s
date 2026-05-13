#──────────────────────────────────────────────────────
#──  Imprimir mensajes en diferentes colores
#──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"

    .text

   .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Poner patron inicial en los leds
    li t0, 0xF00F
    sw t0, 0(s0)

    #--- Borrar pantalla
    ANSI_HOME
    ANSI_CLS

    #-- Cambiar color a verde

    #-- Imprimir mensaje
    PUTSI "----------------------------\n"
    PUTSI "Probando secuencias ansi \n"
    PUTSI "----------------------------\n"

    ANSI_GREEN
    PUTSI "Esto es color verde...\n"

    ANSI_BLUE
    PUTSI "Esto es color azul...\n"

    ANSI_RED
    putsi "Esto es color rojo...\n"

    ANSI_RESET
    putsi "Color reseteado...\n"

    halt




