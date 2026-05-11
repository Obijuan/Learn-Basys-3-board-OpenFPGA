#──────────────────────────────────────────────────────
#──  Hacer ECO de todo lo recibido por el puerto serie
#──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"
    .include "uart.h"
    .include "stdio.h"

    .text

   .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Poner patron inicial en los leds
    li t0, 0xF00F
    sw t0, 0(s0)

    #-- Imprimir mensaje
    PUTCHARI('\n')
    PUTSI "----------------------------\n"
    PUTSI "Activando programa de eco...\n"
    PUTSI "----------------------------\n"


 main_loop:

    #-- Transmitir una A
    PUTCHARI('A')

    halt

    j main_loop


    .data
msga: .string "\nPrograma de eco...\n"




