.include "so.h"
.include "stack.h"
.include "delay.h"

#-- Direccion de los LEDs
.equ LEDS, 0x200000

#-- Pausa a realizar
.equ PAUSA, _50ms

.global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0 -> Direccion de los leds
    li gp, LEDS

loop:
    #-- a0: Valor inicial
   li a0, 0x01

   #-- a1: Bits a desplazar a la izquierda
   li a1, 0x01

   #-- a2: Numero de pasos a dar
   li a2, 16

   jal play1

   #-- Repetir
   j loop

#----- Dependencias
.include "delay.s"
.include "seq.s"


