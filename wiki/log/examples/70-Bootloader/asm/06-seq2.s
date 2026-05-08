 #──────────────────────────────────────────────────────
 #──  seq1: Secuencia 2: Desplazamiento a la izquierda
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"
    .include "delay.h"

    #-- Valor inicial de la secuencia
    .equ VALOR_INI, 0x01

    #-- Numero de desplazamientos
    .equ NSHIFTS, 16

    #-- Pausa entre valores
    .equ PAUSA, _50ms


    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

 main_loop:
    #-- Inicializar la secuencia
    li s1, VALOR_INI

    #-- Numero de desplazamiento a realizar
    li s2, NSHIFTS

 loop_shift:
    #-- Sacar la secuencia actual por los LEDs
    sw s1, 0(s0)

    #-- Pausa
    li a0, PAUSA
    jal delay

    #-- Desplazar a la izquierda
    slli s1, s1, 1

    #-- Queda un desplazamiento menos
    addi s2, s2, -1

    #-- Si es mayor que 0, repetir
    bgt s2, zero, loop_shift

    #-- Desplazamiento completado: Repetir!
    j main_loop



