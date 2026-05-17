#-- Tamaño de la pantalla grafica
.equ GL_width,  80
.equ GL_height,  25


.macro GL_GOTOXY x:req, y:req 
    li a0, \x
    li a1, \y
    jal GL_gotoxy
.endm

.macro GL_SET_PIXEL_RGB_HERE R, G, B
    li a0, \R  #-- RED
    li a1, \G  #-- GREEN
    li a2, \B  #-- BLUE
    jal GL_setpixelRGBhere
.endm

.macro GL_SET_PIXEL_RGB x:req, y:req, R:req, G:req, B: req
    li a0, \x   #-- x
    li a1, \y   #-- y
    li a2, \R   #-- R
    li a3, \G   #-- G
    li a4, \G   #-- B
    jal GL_setpixelRGB
.endm

