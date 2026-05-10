 #──────────────────────────────────────────────────────
 #──  Movimiento de un LED de izquierda a derecha
 #──  con las teclas LEFT y RIGHT
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"


    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

    #-- s1: particula en los leds
    li s1, 0x80   #-- Inicialmente en la derecha


    #--- Bucle principal
 main_loop:

    #-- Leer pulsadores
    jal read_buttons

    #-- a0: Teclas presionadas

    #-- Comprobar si tecla izquierda pulsada
    andi t1, a0, BTN_LEFT
    beq t1, zero, no_left

    #-- Tecla pulsada

    #-- Comprobar limite izquierdo
    li t2, 0x8000
    beq s1, t2, no_left

    #-- No se ha llegado al extremo izquierdo
    #-- Desplazar a la izquierda
    slli s1, s1, 1

 no_left:

    #-- Comprobar si tecla derecha pulsada
    andi t1, a0, BTN_RIGHT
    beq t1, zero, no_right

    #-- Tecla derecha pulsada!!

    #-- Comprobar limite derecho
    li t2, 0x0001
    beq s1, t2, no_right

    #-- Desplazar a la derecha
    srli s1, s1, 1

 no_right:

    #-- Actualizar leds
    sw s1, 0(s0)

    #-- Repetir!
    j main_loop


