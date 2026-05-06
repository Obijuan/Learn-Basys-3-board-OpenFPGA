.include "so.h"
.include "stack.h"
.include "delay.h"

#-- Direccion de los LEDs
.equ LEDS, 0x200000


.global __reset
__reset:

    #-- Inicializar la pila
    li sp, 0x40800

    #-- gp -> Direccion de los leds
    li gp, LEDS

    li a0, 0x5555AAAA  #-- Secuencia
    li a1, _100ms      #-- Pausa
    li a2, 20           #-- Repeticiones
    jal play_seq

    li t0, 0xFFFF
    sw t0, (gp)

    #-- STOP
    halt


#----- Dependencias
.include "delay.s"
.include "seq.s"


