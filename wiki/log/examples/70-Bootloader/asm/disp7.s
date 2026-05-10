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

    #-- Mostrar numero en los leds
    sw a0, 0(t0)

    UNSTACK16

