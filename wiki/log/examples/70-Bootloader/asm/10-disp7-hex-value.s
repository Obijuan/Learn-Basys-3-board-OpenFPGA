 #──────────────────────────────────────────────────────
 #──  Mostrar un numero hexadecimal en 
 #──  el display de 7 segmentos
 #──  Con la tecla UP se incrementa
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"
    .include "stack.h"

    #-- Numero a mostrar en el display
    .equ NUMERO, 0xCAFE

    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- Apagar los leds
    li s0, LEDS_ADDR
    sw zero, 0(s0)

    #-- Numero a mostrar en los displays
    li s1, NUMERO

   #--- Bucle principal
 main_loop:

    #-- Mostrar numero en el display
    mv a0, s1
    jal disp_hex4

    #-- Leer pulsadores
    jal read_buttons

    #-- ¿Boton up?
    andi t1, a0, BTN_UP
    beq t1, zero, main_loop

    #-- Boton apretado
    #-- Incrementar el numero
    addi s1, s1, 1

    #-- Repetir
    j main_loop


