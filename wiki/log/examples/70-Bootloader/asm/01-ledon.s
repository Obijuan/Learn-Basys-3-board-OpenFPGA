    .include "peripherals.h"
    .include "so.h"

#-- El punto de entrada es: __reset
#-- Esta indicado en el linker script
    .global __reset
__reset:

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

    #-- Sacar el 1 por los LEDS: encender LED0!
    li t0, 1
    sw t0, (s0)

    #-- STOP!
    halt

