 #──────────────────────────────────────────────────────
 #──  LED parpadeante
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"
    .include "delay.h"

#-- LED que se quiere parpadear
    .equ LED, LED0



    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

    #-- Meter en t1 el LED
    li t0, LED0

loop:
    #-- Mostrar estado actual del LED
    sw t0, 0(s0)

    #-- Cambiar de estado
    xori t0, t0, LED
    
    #-- Pausa
    li a0, _250ms
    jal delay

    #-- Repetir
    j loop



