 #──────────────────────────────────────────────────────
 #-- Sacar un valor de 16 bits por los LEDs
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"

#-- Valor a mostrar en los LEDs
    .equ VALOR, 0xC003

#-- El punto de entrada es: __reset
#-- Esta indicado en el linker script
    .global __reset
__reset:

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

    #-- Sacar el valor por los LEDs
    li t0, VALOR
    sw t0, (s0)

    #-- STOP!
    halt

