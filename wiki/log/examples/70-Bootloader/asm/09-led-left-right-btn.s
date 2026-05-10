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

    #-- s1: Direccion de los pulsadores
    li s1, BUTTONS_ADDRESS

    #-- t0: particula en los leds
    li t0, 1   #-- Inicialmente en la derecha

    #-- Leer estado anterior de los pulsadores
    lw t1, 0(s1)

    #--- Bucle principal
 main_loop:

    #-- Leer estado actual de los pulsadores
    lw t2, 0(s1)

    #-- Detectar cambio en pulsadores
    #-- t3: Cambio en pulsadores
    xor t3, t2, t1

    #-- Detectar presion de tecla
    and t4, t3, t2

    #-- Comprobar si tecla izquierda pulsada
    andi t5, t4, BTN_LEFT
    beq t5, zero, no_left

    #-- Tecla pulsada!!!

    #-- Comprobar limite izquierdo
    li t6, 0x8000
    beq t0, t6, no_left

    #-- No se ha llegado al extremo izquierdo
    #-- Desplazar a la izquierda
    slli t0, t0, 1

 no_left:

    #-- Comprobar si tecla derecha pulsada
    andi t5, t4, BTN_RIGHT
    beq t5, zero, no_right

    #-- Tecla derecha pulsada!!

    #-- Comprobar limite derecho
    li t6, 0x0001
    beq t0, t6, no_right

    #-- Desplazar a la derecha
    srli t0, t0, 1

 no_right:

    #-- Actualizar leds
    sw t0, 0(s0)

    #-- Guardar estado actual como anterior
    mv t1, t2   

    #-- Repetir!
    j main_loop



