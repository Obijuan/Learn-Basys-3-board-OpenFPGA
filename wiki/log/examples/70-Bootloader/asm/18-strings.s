    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"
    .include "uart.h"
    .include "stack.h"

    .text

       .global __reset
__reset:

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Poner patron inicial en los leds
    li t0, 0xF00F
    sw t0, 0(s0)

    #--- Borrar pantalla
    ANSI_HOME
    ANSI_CLS


    #-- Imprimir numero en binario en el buffer
    la a0, buff
    li a1, 0x1
    li a2, 0     #-- sin Eliminar ceros iniciales
    jal sprint_bin4

    #-- Imprimir el buffer
    la a0, buff
    jal puts

    PUTCHARI '\n'


    #-- Imprimir numero en binario en el buffer
    la a0, buff
    li a1, 0x1
    li a2, 1     #-- Eliminar ceros iniciales
    jal sprint_bin4

    #-- Imprimir el buffer
    la a0, buff
    jal puts

    PUTCHARI '\n'


    halt


#-- a0: Direccion del buffer de la cadena
#-- a1: Numero a "imprimir"
#-- a2: Eliminar 0s iniciales (0=NO, 1=si)
sprint_bin4:
    STACK16

    #-- Guardar los parametros
    sw a0, 0(sp)
    sw a2, 4(sp)

    #-- Convertir a array bcd
    #-- Guardarlo en un buffer interno
    la a0, __buff
    jal bin4_to_bcd_array

    #-- Convertir a cadena
    la a0, __buff
    li a1, 4  #-- Tamaño en bytes
    jal bcd_array_to_string

    #-- Comprobar si hay que eliminar ceros iniciales o no
    lw a2, 4(sp)
    beq a2, zero, no_remove_ceros

    #-- Hay que eliminar los 0s
    la a0, __buff
    jal str_remove_leading_zeros

    #-- a0: cadena sin ceros
    j cont
    
no_remove_ceros:
    #-- Seleccionar cadena desde el principio
    la a0, __buff

cont:

    #-- Copiar el numero-cadena en el buffer de la cadena
    #-- La cadena origen a0 contiene bien el numero completo
    #-- o bien apunta al numero sin 0s iniciales
    lw a1, 0(sp)  #-- buffer destino
    jal strcpy

1:
    UNSTACK16



    .data
__buff: .space 33
buff:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
