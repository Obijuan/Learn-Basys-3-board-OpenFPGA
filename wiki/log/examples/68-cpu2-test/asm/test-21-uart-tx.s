.include "so.h"
.include "stack.h"
.include "delay.h"

#-- Pausa a realizar en secuencia leds
.equ PAUSA, _50ms

#-- Direccion de los LEDs
.equ LEDS, 0x200000

#-- Direccion de la UART
.equ UART, 0x210000


.global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- gp -> Direccion de los leds
    li gp, LEDS

    #-- tp -> Direccion de la UART
    li tp, UART

    #-- Envio de un byte a la UART
    li t0, 'A'
    sw t0, (tp)


#------------------------------------
#-- TESTs pasado con exito
#------------------------------------

    #-- Mostrar una secuencia
1:
    li a0, 0x01  #-- Valor inicial seq
    li a1, 0x01  #-- Bits a desplazar a la izq
    li a2, 16    #-- Numero de pasos
    jal play1
    j 1b


#----- Dependencias
.include "delay.s"
.include "seq.s"

