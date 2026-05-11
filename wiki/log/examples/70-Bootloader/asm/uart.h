#-- Imprimir un caracter LITERAL (inmediato)
.macro PUTCHARI char:req
    li a0, \char
    jal putchar
.endm

#-- Imprimir un caracter situado en un registro
.macro PUTCHARR reg:req
    mv a0, \reg
    jal putchar
.endm
