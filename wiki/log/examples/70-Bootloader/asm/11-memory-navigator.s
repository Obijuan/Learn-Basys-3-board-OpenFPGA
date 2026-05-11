#──────────────────────────────────────────────────────
 #──  Memory-navigator
 #──    Observar el contenido de la memoria en los
 #──  displays de 7 segmentos
 #──  Con las teclas UP-DOWN se cambiar la direccion actual
 #── Con LEFT-RIGHT se cambia el peso de la visualizacion:
 #──   * Media palabra alta
 #──   * Media palabra baja 
 #──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"


    .text
   .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- s1: Direccion actual
    li s1, MEMORY_ADDR

    #-- s2: Media palabra a mostrar:
    #--   0: Baja, 1: alta
    li s2, 0

 #-------- BUCLE PRINCIPAL
 main_loop:

    #-- Mostrar direccion actual en los leds
    sw s1, 0(s0)

    #-- Leer direccion actual
    lw a0, 0(s1)

    #-- Mostrar en los displays la parte alta o baja
    beq s2, zero, parte_baja

    #-- Mostrar la parte alta: Hay que desplazar a0 >> 16
    srli a0, a0, 16
    j show

    #-- Para la parte baja: no se hace nada
 parte_baja:

 show:
    #-- Mostrar contenido de la direccion actual
    #-- en el display de 7 segmentos
    jal disp_hex4

    #-- Si estamos viendo la parte baja, 
    #-- activar el punto!!
    bne s2, zero, cont

    #-- Mostrar el punto!
    addi a0, a0, 0x80
    li t0, SEGMENTS_ADDR
    sw a0, 0(t0)

 cont:
    #-- Lectura de los pulsadores
    jal read_buttons

    #-- ¿Boton down?
    andi t1, a0, BTN_DOWN
    bne t1, zero, button_down

    #-- ¿Boton up?
    andi t1, a0, BTN_UP
    bne t1, zero, button_up

    #-- ¿Boton left?
    andi t1, a0, BTN_LEFT
    bne t1, zero, button_left

    #-- ¿Boton right?
    andi t1, a0, BTN_RIGHT
    bne t1, zero, button_right
    

    j main_loop


 #-- Tecla DOWN pulsada:
 #-- Incrementar la direccion a la siguiente
 button_down: 
    addi s1, s1, 4
    j main_loop

 #-- Tecla UP pulsada:
 #-- Decrementar la direccion (ver la anterior)
 button_up:
    addi s1, s1, -4
    j main_loop

 #-- Tecla LEFT
 #-- Mostrar la parte alta
 button_left:
    li s2, 1
    j main_loop

#-- Tecla RIGHT
#-- Mostrar la parte baja
 button_right:
    li s2, 0
    j main_loop
