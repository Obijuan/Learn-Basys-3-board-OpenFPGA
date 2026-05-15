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

    SPRINTI_BUFF buffer, "test..."
    SPRINTI "test2...\n"
    la a0, buffer
    jal puts

    SPRINTI_BUFF buffer, "\033["
    #SPRINTI_BUFF buffer, "ESC["
    SPRINTI_UINT 10
    SPRINTI ";10H"

    # SPRINTI_CHAR ';'
    # SPRINTI_UINT 10
    # SPRINTI_CHAR 'H'
    # #SPRINTI_CHAR '\n'

    la a0, buffer
    jal puts

    #PUTSI "\033[10;10H"
    PUTSI "**Hola2\n"

    

        .data
msg1:    .string "Probando..."
buffer:   .space 255
buffer_2: .space 255

    halt

# static inline void GL_gotoxy(int x, int y) {
#     printf("\033[%d;%dH",y,x);
# }

