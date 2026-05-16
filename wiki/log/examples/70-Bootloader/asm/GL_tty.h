

.macro GL_GOTOXY x:req, y:req 
    li a0, \x
    li a1, \y
    jal GL_gotoxy
.endm

