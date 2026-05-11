#──────────────────────────────────────────────────────
#──  Mostrar los switches en los LEDs y en el display
#──  de 7 segmentos
#──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"

    .text

   .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- s1: Acceso a los Switches
    li s1, SWITCHES_ADDR

 main_loop:

    #-- Leer switches
    lw a0, 0(s1)

    #-- Mostrarlos en los leds
    sw a0, 0(s0)

    #-- Mostrarlos en los displays de 7 segmentos
    jal disp_hex4

    #-- Repetir
    j main_loop


