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
#-- Imprimir numero binario de 4 bit en consola
#---------------------------------------------------
.macro PRINT_BIN4I num:req
    li a0, \num
    li a1, 4
    li a2, 0  #-- Mostrar 0s iniciales
    jal print_bin
.endm

#---------------------------------------------------
#-- Imprimir numero binario de 16 bit en consola
#---------------------------------------------------
.macro PRINT_BIN16I num:req
    li a0, \num
    li a1, 16
    li a2, 0  #-- Mostrar 0s iniciales
    jal print_bin
.endm

#---------------------------------------------------
#-- Imprimir numero binario de 32 bit en consola
#---------------------------------------------------
.macro PRINT_BIN32I num:req
    li a0, \num
    li a1, 32
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

#---------------------------------------------------
#-- Imprimir numero hexadecimal de 8 bit en consola
#---------------------------------------------------
.macro PRINT_HEX4I num:req
    li a0, \num
    li a1, 4
    li a2, 0  #-- Mostrar 0s iniciales
    jal print_hex
.endm

#---------------------------------------------------
#-- Imprimir numero hexadecimal de 16 bit en consola
#---------------------------------------------------
.macro PRINT_HEX16I num:req
    li a0, \num
    li a1, 16
    li a2, 0  #-- Mostrar 0s iniciales
    jal print_hex
.endm

#---------------------------------------------------
#-- Imprimir numero hexadecimal de 32 bit en consola
#---------------------------------------------------
.macro PRINT_HEX32I num:req
    li a0, \num
    li a1, 32
    li a2, 0  #-- Mostrar 0s iniciales
    jal print_hex
.endm


#---------------------------------------------------
#-- Imprimir numero decimal de 8 bit en consola
#---------------------------------------------------
.macro PRINT_UINT8I num:req
    li a0, \num
    li a1, 8
    li a2, 1  #-- Eliminar 0s iniciales
    jal print_uint
.endm

#---------------------------------------------------
#-- Imprimir numero decimal de 4 bit en consola
#---------------------------------------------------
.macro PRINT_UINT4I num:req
    li a0, \num
    li a1, 4
    li a2, 1  #-- Eliminar 0s iniciales
    jal print_uint
.endm

#---------------------------------------------------
#-- Imprimir numero decimal de 16 bit en consola
#---------------------------------------------------
.macro PRINT_UINT16I num:req
    li a0, \num
    li a1, 16
    li a2, 1  #-- Eliminar 0s iniciales
    jal print_uint
.endm

#---------------------------------------------------
#-- Imprimir numero decimal de 32 bit en consola
#---------------------------------------------------
.macro PRINT_UINT32I num:req
    li a0, \num
    li a1, 32
    li a2, 1  #-- Eliminar 0s iniciales
    jal print_uint
.endm
