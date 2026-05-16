    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"
    .include "GL_tty.h"

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

    li a0, 0
    li a1, 1  #-- Eliminar 0s iniciales
    jal print_uint

    # mv a1, \reg
    # li a2, 1  #-- Eliminar 0s iniciales
    # jal sprint_uint

    # la a0, GL_buff
    # jal puts

    # GL_GOTOXY 10, 5
    # PUTSI "Hola"

    # GL_GOTOXY 11, 6
    # PUTSI "Test"

    # li a0, 0x78  #-- RED
    # li a1, 0     #-- GREEN
    # li a2, 0     #-- BLUE

    # mv s0, a0
    # mv s1, a1
    # mv s2, a2

    # #-- Imprimir el codigo ansi
    # la a0, GL_buff
    # la a1, ANSI_RGB
    # jal sprint

    # #-- Color RED
    # mv a1, s0
    # li a2, 1   #-- Eliminar espacios iniciales
    # jal sprint_uint

    # #-- Imprimir ';'
    # li a1, ';'
    # jal sprint_char

    # #-- Color GREEN
    # mv a1, s1
    # li a2, 1
    # jal sprint_uint


    # la a0, GL_buff
    # jal puts
    
#     /**
#  * \brief Sets the current graphics position
#  * \param[in] R , G , B the RGB color of the pixel, in [0..255]
#  * \details Typically used by programs that draw all pixels sequentially,
#  *  like a raytracer. After each line, one can either printf("\n") or
#  *  call GL_gotoxy(). If you want to draw individual pixels in an
#  *  arbitrary order, use GL_setpixelRGB(x,y,R,G,B)
#  */
# static inline void GL_setpixelRGBhere(uint8_t R, uint8_t G, uint8_t B) {
#     // set background color, print space 
#     printf("\033[48;2;%d;%d;%dm ",(int)R,(int)G,(int)B); 
# }


    halt
    
    .data
GL_buff: .space 30
ESC: .string "ESC["
ANSI_RGB: .string "ESC[48;2;"


    #-- DEBUG
    # li t0, 0x00200000
    # li t1, 1
    # sw t1, 0(t0)
