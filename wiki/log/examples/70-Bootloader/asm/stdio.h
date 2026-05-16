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
#-- Imprimir numero decimal en la consola
#---------------------------------------------------
.macro PRINT_UINTI num:req
    li a0, \num
    li a1, 1  #-- Eliminar 0s iniciales
    jal print_uint
.endm

#---------------------------------------------------
#-- Imprimir numero decimal en la consola
#---------------------------------------------------
.macro SPRINTI_UINT_BUFF buff:req, num:req
    la a0 \buff
    li a1, \num  
    li a2, 1  #-- Eliminar 0s iniciales
    jal sprint_uint
.endm


.macro SPRINTI_UINT num:req
    li a1, \num  
    li a2, 1  #-- Eliminar 0s iniciales
    jal sprint_uint
.endm

.macro SPRINTI_CHAR car:req
    li a1, \car  
    jal sprint_char
.endm

#-----------------------------------------
#-- Imprmir una cadena en un buffer
#-----------------------------------------
.macro SPRINTI_BUFF buff, str
    .data
msg\@:  .string "\str"

    .text
    la a0, \buff
    la a1, msg\@
    jal sprint
.endm

.macro SPRINTI str
    .data
msg\@:  .string "\str"

    .text
    la a1, msg\@
    jal sprint
.endm

.macro SPRINTL_BUFF buff, label
    la a0, \buff
    la a1, \label
    jal sprint
.endm

#--------------------------------------------
#-- Imprimir un numero de 8 bits en binario
#--------------------------------------------
.macro SPRINTI_BIN8 label:req, num:req
    la a0, \label  #-- Buffer
    li a1, \num    #-- Numero
    li a2, 8      #-- Tamaño: 8 bits
    li a3, 0      #-- Mostrar 0s iniciales
    jal sprint_bin
.endm
