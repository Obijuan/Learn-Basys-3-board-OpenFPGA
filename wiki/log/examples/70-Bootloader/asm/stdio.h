#---------------------------
#-- MACROS
#---------------------------


#------------------------ PUTS ---------------------------
#------------------------------------------------
#-- Imprimir cadena cuya direccion esta indicada
#-- en el registro proporcionado
#------------------------------------------------
# .macro PUTSR(%reg)
#   mv a0, %reg
#   jal puts
# .end_macro

#----------------------------------------
#-- Se pasa como parametro la etiqueta
#----------------------------------------
.macro PUTSL label:req
  la a0, \label
  jal puts
.endm

#-----------------------------------------------
#-- Se pasa como paramtro una cadena LITERAL  
#-----------------------------------------------
.macro PUTSI str:req
	 .data
msg\@: .string "\str"

    .text
    la a0, msg\@
    jal puts
.endm

#--------------------------------------------
#-- Imprimir un numero de 8 bits en binario
#--------------------------------------------
.macro SPRINT_BIN8 label:req, num:req
    la a0, \label  #-- Buffer
    li a1, \num    #-- Numero
    li a2, 8      #-- Tamaño: 8 bits
    li a3, 0      #-- Mostrar 0s iniciales
    jal sprint_bin
.endm

#---------------------------------------------------
#-- Imprimir numero binario de 8 bit en consola
#---------------------------------------------------
.macro PRINT_BIN8I num:req
    li a0, \num
    li a1, 8
    li a2, 0  #-- Mostrar 0s iniciales
    jal print_bin
.endm

#---------------------------------------------------
#-- Imprimir numero hexadecimal de 8 bit en consola
#---------------------------------------------------
.macro PRINT_HEX8I num:req
    li a0, \num
    li a1, 8
    li a2, 0  #-- Mostrar 0s iniciales
    jal print_hex
.endm

