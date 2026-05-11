#──────────────────────────────────────────────────────
#──    BIBLIOTECA PARA EL DISPLAY DE 7 SEGMENTOS
#──────────────────────────────────────────────────────
    .include "peripherals.h"
    .include "stack.h"


#--------------------------------------------------------
#-- Convertir un digito bcd a los segmentos de un
#-- display
#--
#-- ENTRADAS:
#--    a0: Digito bcd
#--
#-- SALIDA:
#--    a0: Segmentos
#--------------------------------------------------------
    .global bcd2disp
bcd2disp:
    #-- Direccion base de la tabla
    la t0, tabla

    #-- a0: Digito BCD 
    andi a0, a0, 0xF

    #-- Codificar digito 0
    add t1, t0, a0
    lb a0, 0(t1)

    #-- Devolverlo
    ret


    .data
tabla:
    .byte 0x3F  #-- Digito 0
    .byte 0x06  #-- Digito 1
    .byte 0x5B  #-- Digito 2
    .byte 0x4F  #-- Digito 3
    .byte 0x66  #-- Digito 4
    .byte 0x6D  #-- Digito 5
    .byte 0x7D  #-- Digito 6
    .byte 0x07  #-- Digito 7
    .byte 0x7F  #-- Digito 8
    .byte 0x6F  #-- Digito 9
    .byte 0x77  #-- Digito A
    .byte 0x7C  #-- Digito B
    .byte 0x39  #-- Digito C
    .byte 0x5E  #-- Digito D
    .byte 0x79  #-- Digito E
    .byte 0x71  #-- Digito F
    

#--------------------------------------------------------
#-- Mostrar un numero de 1 digito bcd en el
#-- display de 7 segmentos
#--
#-- ENTRADAS:
#--    a0: Digito bcd
#--------------------------------------------------------
    .text
    .global disp_bcd
disp_bcd:
    STACK16

    #-- Convertir digito bcd a 7 segmentos
    jal bcd2disp

    #-- Obtener direccion del 7-segmentos
    li t0, SEGMENTS_ADDR

    #-- Mostrar numero en el display
    sw a0, 0(t0)

    UNSTACK16


#------------------------------------------------------
#-- Mostrar en el display de 7 segmentos un numero
#-- hexadecimal de 2 digitos
#--
#-- ENTRADA:
#--   a0: Numero a mostrar
#--
#------------------------------------------------------
    .global disp_hex2
disp_hex2:

    STACK16

    #-- Guardar registros estaticos en la pila
    sw s0, 0(sp)
    sw s1, 4(sp)

    #-- Guardar a0
    mv s0, a0

    #-- Convertir digito BCD 0
    jal bcd2disp

    #-- Almacenar digito 0 
    mv s1, a0

    #-- Convertir digito BCD 1
    srli a0, s0, 4

    jal bcd2disp

    #-- Almacenar digito 1
    slli a0, a0, 8
    or s1, s1, a0

    #-- Obtener direccion del 7-segmentos
    li t0, SEGMENTS_ADDR

    #-- Mostrar numero en el display
    sw s1, 0(t0)

    #-- Recuperar registros estaticos
    lw s0, 0(sp)
    lw s1, 4(sp)
    UNSTACK16



#------------------------------------------------------
#-- Mostrar en el display de 7 segmentos un numero
#-- hexadecimal de 4 digitos
#--
#-- ENTRADA:
#--   a0: Numero a mostrar
#--
#------------------------------------------------------
    .global disp_hex4
disp_hex4:

    STACK16

    #-- Guardar registros estaticos en la pila
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    #-- s0: Numero inicial
    mv s0, a0

    #-- s1: Segmentos
    li s1, 0

    #-- s2: Contador de numeros
    li s2, 0

 next_digit:

    #-- Convertir digito BCD i
    mv a0, s0
    jal bcd2disp

    #-- Desplazar a0 8*i bits a la izqueirda
    #-- t0 = s2 * 8
    slli t0, s2, 3
    sll a0, a0, t0

    #-- Guardar segmentos
    or s1, s1, a0

    #-- Siguiente digito bcd
    srli s0, s0, 4

    #-- Siguiente valor de 7 seg
    #slli s1, s1, 8

    #-- Siguiente digito
    addi s2, s2, 1

    #-- Repetir mientras queden digitos 
    li t2, 4 
    blt s2, t2, next_digit

    #-- Hemos terminado. Mostrar el numero en el display 
    #-- de 7 segmentos

    #-- Obtener direccion del 7-segmentos
    li t0, SEGMENTS_ADDR

    #-- Mostrar numero en el display
    sw s1, 0(t0)

    #-- Recuperar registros estaticos
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)

    UNSTACK16

