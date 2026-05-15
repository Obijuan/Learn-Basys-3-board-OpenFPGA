    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"


    .text

       .global __reset
__reset:

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Poner patron inicial en los leds
    li t0, 0xF00F
    sw t0, 0(s0)

    #--- Borrar pantalla
    ANSI_HOME
    ANSI_CLS

    PUTSI "\033[5;10H"
    PUTSI "Hola\n"

    la a0, buffer
    la a1, msg1
    jal sprint

    la a1, msg1
    jal sprint

    #SPRINT buffer, "test..."

    #la a1, msg1
    #jal sprint


    la a0, buffer
    jal puts

        .data
msg1:    .string "Probando..."
buffer: .space 255

    halt

# static inline void GL_gotoxy(int x, int y) {
#     printf("\033[%d;%dH",y,x);
# }

