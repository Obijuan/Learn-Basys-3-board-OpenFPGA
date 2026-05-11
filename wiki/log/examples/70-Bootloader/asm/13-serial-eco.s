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

    #-- Esperar a que se reciba un caracter
    jal getchar

    #-- Mostrar caracter recibido en los leds
    sb a0, (s0)

    #-- Hacer eco!
    jal putchar

    #-- Repetir
    j main_loop





