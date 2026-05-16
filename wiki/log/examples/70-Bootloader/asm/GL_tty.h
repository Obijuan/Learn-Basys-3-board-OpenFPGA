

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
