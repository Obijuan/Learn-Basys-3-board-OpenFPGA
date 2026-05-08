 #──────────────────────────────────────────────────────
 #──    Encender el LED 0
 #──────────────────────────────────────────────────────

    .include "peripherals.h"
    .include "so.h"

#-- El punto de entrada es: __reset
#-- Está indicado en el linker script
    .global __reset
__reset:

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

    #-- Encender LED0!
    li t0, LED0
    sw t0, (s0)

    #-- STOP!
    halt

