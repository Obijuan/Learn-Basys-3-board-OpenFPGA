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
    jal sprint_bin4

    #-- Imprimir el buffer
    la a0, buff
    jal puts

    PUTCHARI '\n'

    halt


#-- a0: Direccion del buffer de la cadena
#-- a1: Numero a "imprimir"
sprint_bin4:
    STACK16

    #-- Guardar los parametros
    sw a0, 0(sp)
    sw a1, 4(sp)

    #-- Convertir a array bcd
    #-- Guardarlo en un buffer interno
    la a0, __buff
    jal bin4_to_bcd_array

    #-- Convertir a cadena
    la a0, __buff
    li a1, 4  #-- Tamaño en bytes
    jal bcd_array_to_string

    #-- Copiar cadena al buffer de la cadena
    la a0, __buff
    la a1, buff
    jal strcpy

    UNSTACK16



    .data
__buff: .space 33
buff:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
