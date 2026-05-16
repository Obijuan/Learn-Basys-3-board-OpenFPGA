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

    li s0, 5;  #-- Coordenada y
    li s1, 10; #-- Coordenada x

    #-- Codigo ANSI locate: "\033[y;xH"
    SPRINTL_BUFF buffer, _ANSI_LOCATE
    SPRINTR_UINT s0    #-- Coordenada y
    SPRINTI_CHAR ';'
    SPRINTR_UINT s1   #-- Coordenada x
    SPRINTI_CHAR 'H'

    la a0, buffer
    jal puts

    #PUTSI "\033[5;10H"
    PUTSI "Hola\n"

    
    SPRINTI_BUFF buffer, "test..."
    SPRINTI "test2...\n"
    la a0, buffer
    jal puts

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

