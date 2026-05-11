#──────────────────────────────────────────────────────
#──  Hacer ECO de todo lo recibido por el puerto serie
#──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"
    .include "stack.h"

    .text

   .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Apagar los leds
    sw zero, 0(s0)

    #-- Imprimir mensaje de bienvenida
    la a0, msg1
    jal puts


 main_loop:

    #-- Transmitir una A
    li a0, 'A'
    jal putchar

    halt

    j main_loop


    .data
msg1: .string "\nPrograma de eco...\n"




