 #──────────────────────────────────────────────────────
 #──  LED parpadeante
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"
    .include "delay.h"

#-- LED que se quiere parpadear
    .equ LED, LED15

    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

    #-- Meter en t1 el LED
    li t0, LED

loop:
    #-- Mostrar estado actual del LED
    sw t0, 0(s0)

    #-- Cambiar de estado
    li t1, LED
    xor t0, t0, t1
    
    #-- Pausa
    li a0, _250ms
    jal delay

    #-- Repetir
    j loop



