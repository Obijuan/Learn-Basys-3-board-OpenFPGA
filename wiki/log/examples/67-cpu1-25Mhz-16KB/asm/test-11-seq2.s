.include "so.h"
.include "stack.h"
.include "delay.h"

#-- Direccion de los LEDs
.equ LEDS, 0x200000


.global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0 -> Direccion de los leds
    li gp, LEDS

    li t0, 0xAAAA
    sw t0, (gp)
    j .

    li a0, 0x5555AAAA  #-- Secuencia
    li a1, _100ms      #-- Pausa
    li a2, 3           #-- Repeticiones
    jal play_seq

    li t0, 0xFF
    sw gp, (s0)

    #-- STOP
    halt


#----- Dependencias
.include "delay.s"
.include "seq.s"


