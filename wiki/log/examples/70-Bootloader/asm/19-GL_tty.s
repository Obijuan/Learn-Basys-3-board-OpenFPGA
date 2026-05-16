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
    ANSI_RESET
    ANSI_HOME
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
