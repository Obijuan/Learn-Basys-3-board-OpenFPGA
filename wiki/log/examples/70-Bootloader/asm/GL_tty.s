#──────────────────────────────────────────────────────
#──    ANSI GRAPHICS LIBRARY
#──
#──  Ported from ansi_graphics.h by Bruno Levy
#──────────────────────────────────────────────────────
    .include "stack.h"

#-- Tamaño de la pantalla grafica
.equ GL_widtht,  80
.equ GL_height,  25


#──────────────────────────────────────────────────────
#──  Situar el cursor en la posicion (x,y)
#──
#──  ENTRADAS:
#──    a0: Coordenada x (0-79)
#──    a1: Coordenada y (0-24)
#──────────────────────────────────────────────────────
    .global GL_gotoxy
GL_gotoxy:
    STACK16

    #-- Guardar registros estaticos
    sw s0, 0(sp)
    sw s1, 4(sp)

    #-- Guardar parametros
    mv s0, a0
    mv s1, a1

    #--------- Codigo ANSI locate: "\033[y;xH"

    #-- Imprimir el codigo ansi
    la a0, _GL_buff
    la a1, _ESC
    jal sprint

    #-- Coordenada y
    mv a1, s1
    li a2, 1   #-- Eliminar espacios iniciales
    jal sprint_uint

    #-- Imprimir ';'
    li a1, ';'
    jal sprint_char

    #-- Coordenada x
    mv a1, s0
    li a2, 1
    jal sprint_uint

    #-- Imprimir 'H'
    li a1, 'H'
    jal sprint_char

    la a0, _GL_buff
    jal puts

    #-- Recuperar registros estaticos
    lw s0, 0(sp)
    lw s1, 4(sp)

    UNSTACK16


    .data
_GL_buff: .space 20

