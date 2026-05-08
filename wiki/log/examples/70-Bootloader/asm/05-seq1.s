 #──────────────────────────────────────────────────────
 #──  seq1: Secuencia 1: Secuencia de 2 estados
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"
    .include "delay.h"

    #-- Los dos valores de la secuencia
    .equ VALOR1, 0xAAAA
    .equ VALOR2, 0x5555

    #-- Pausa entre valores
    .equ PAUSA, _250ms

    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

 loop:
    #-- Establecer valor 1 de la secuencia
    li t0, VALOR1
    sw t0, 0(s0)

    #-- Pausa
    li a0, PAUSA
    jal delay

    #-- Establecer valor 2 de la secuencia
    li t0, VALOR2
    sw t0, 0(s0)

    #-- Pausa
    li a0, PAUSA
    jal delay

    #-- Repetir
    j loop



