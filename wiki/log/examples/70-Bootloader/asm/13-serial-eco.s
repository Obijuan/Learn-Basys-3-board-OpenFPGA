#──────────────────────────────────────────────────────
#──  Hacer ECO de todo lo recibido por el puerto serie
#──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"
    .include "stack.h"

    .text

   .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

 main_loop:

    #-- Mostrar valor en leds
    li t0, 0xF00F
    sw t0, 0(s0)

    #-- Transmitir una A
    li a0, 'A'
    jal putchar

    halt

    j main_loop





