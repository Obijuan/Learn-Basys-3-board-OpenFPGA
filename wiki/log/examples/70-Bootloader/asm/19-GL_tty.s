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

    #-- Inicializar la biblioteca
    jal GL_init

    #-- Coordenada x
    li s0, 0

    #-- Coordenada y
    li s1, 0

    #-- Componente Roja
    li s2, 0x78

    #--- Bucle
 loop_y:
    li t0, GL_height
    bge s1, t0, end_loop_y

 loop_x:
    li t0, GL_width
    bge s0, t0, end_loop_x

    #-- Recalcular componente RED
    # int r = (24-i)*5;
    # s2 = (24-s1)*5
    li t0, 24
    sub a0, t0, s1
    li a1, 5
    jal __mulsi3
    mv s2, a0


    #-- Dibujar pixel
    mv a0, s0   #-- x
    mv a1, s1   #-- y
    mv a2, s2   #-- R
    li a3, 0   #-- G
    li a4, 0   #-- B
    jal GL_setpixelRGB

    #-- Incrementar posicion x
    addi s0, s0, 1

    #-- Repetir x
    j loop_x

end_loop_x:

    #-- Incrementar posicion y
    addi s1, s1, 1

    #-- x=0
    li s0, 0

    j loop_y

end_loop_y:

    #-- Terminar
    jal GL_terminate

    halt


# int main() {
#     GL_init();
#     for(int i=0; i<GL_height; ++i) {
#         for(int j=0; j<GL_width; ++j) {
#             int r = (24-i)*5;
#             int g = i*5;
#             int b = j*3;
#             GL_setpixelRGB(j,i,r,g,b);
#         }
#     }
#     GL_terminate();
# }




