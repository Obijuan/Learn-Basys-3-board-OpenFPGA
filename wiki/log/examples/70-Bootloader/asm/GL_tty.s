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

#──────────────────────────────────────────────────────
#──  Establecer el color de la posicion actual (RGB)
#──
#──  ENTRADAS:
#──    a0: Color R (0-255)
#──    a1: Color G (0-255)
#──    a2: Color B (0-255)
#──────────────────────────────────────────────────────
    .global GL_setpixelRGBhere
GL_setpixelRGBhere:
    STACK16

    #-- Guardar los registros estaticos
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)


    #-- Guardar los parametros
    mv s0, a0
    mv s1, a1
    mv s2, a2

    #-- Imprimir el codigo ansi
    la a0, _GL_buff
    la a1, _ANSI_RGB
    jal sprint

    #-- Color RED
    mv a1, s0
    li a2, 1   #-- Eliminar espacios iniciales
    jal sprint_uint

    #-- Imprimir ';'
    li a1, ';'
    jal sprint_char

    #-- Color GREEN
    mv a1, s1
    li a2, 1
    jal sprint_uint

    #-- Imprimir ';'
    li a1, ';'
    jal sprint_char

    #-- Color BLUE
    mv a1, s2
    li a2, 1
    jal sprint_uint

    #-- Imprimir 'm'
    li a1, 'm'
    jal sprint_char

    #-- Imprimir ' '
    li a1, ' '
    jal sprint_char

    #-- Imprimir la cadena
    la a0, _GL_buff
    jal puts

    #-- Recuperar los registros estaticos
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)

    UNSTACK16


#──────────────────────────────────────────────────────
#──  Establecer el color (RGB) de la posicion x,y
#──
#──  ENTRADAS:
#──    a0: x
#──    a1: y
#──    a2: Color R (0-255)
#──    a3: Color G (0-255)
#──    a4: Color B (0-255)
#──────────────────────────────────────────────────────
    .global GL_setpixelRGB
GL_setpixelRGB:
    STACK16

    #-- Almacenar registros estáticos
    PUSH3 s0, s1, s2

    #-- Guardar colores RGB
    mv s0, a2
    mv s1, a3
    mv s2, a4

    #-- Ir a la posicion (x,y)
    jal GL_gotoxy

    #-- Dibujar pixel RGB
    mv a0, s0
    mv a1, s1
    mv a2, s2
    jal GL_setpixelRGBhere

    #-- Recuperar registros estaticos
    POP3 s0, s1, s2

    UNSTACK16

    .data
_GL_buff: .space 20

