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

    #--- Borrar pantalla
    ANSI_RESET
    ANSI_CLS

    GL_GOTOXY 10, 5
    PUTSI "Hola"

    GL_GOTOXY 11, 6
    PUTSI "Test"

    GL_SET_PIXEL_RGB_HERE 0x78, 0, 0
    GL_SET_PIXEL_RGB_HERE 0x73, 0, 0
    GL_SET_PIXEL_RGB_HERE 0x6E, 0, 0

    GL_SET_PIXEL_RGB 5,  6,  0, 0x80, 0
    GL_SET_PIXEL_RGB 30, 6,  0, 0x40, 0
    GL_SET_PIXEL_RGB 5,  8,  0, 0, 0xFF
    GL_SET_PIXEL_RGB 30, 8,  0, 0, 0x80a


    halt
    
    .data

    #-- DEBUG
    # li t0, 0x00200000
    # li t1, 1
    # sw t1, 0(t0)


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


# /**
#  * \brief Call this function each time graphics should be cleared
#  */
# static inline void GL_clear() {
#     GL_restore_default_colors();
#     printf("\033[2J"); // clear screen
# }

# /**
#  * \brief Moves current drawing position to top-left corner
#  * \see GL_setpixelRGBhere() and GL_set2pixelsRGBhere()
#  */
# static inline void GL_home() {
#     printf("\033[H");
# }

# /**
#  * \brief Call this function before starting drawing graphics 
#  *  or each time graphics should be cleared
#  */
# static inline void GL_init() {
#     printf("\033[?25l"); // hide cursor
#     GL_home();
#     GL_clear();
# }


# /**
#  * \brief Call this function at the end of the program
#  */
# static inline void GL_terminate() {
#     GL_restore_default_colors();
#     GL_gotoxy(0,GL_height);
#     printf("\033[?25h"); // show cursor
# }
