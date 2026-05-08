 #──────────────────────────────────────────────────────
 #──  Mostrar 2 valores en los LEDs
 #──  Valor 1 --> Pausa --> Valor 2 ---> HALT
 #──────────────────────────────────────────────────────
 
    .include "peripherals.h"
    .include "so.h"
    .include "delay.h"

#-- Valores a mostrar en los LEDs
    .equ VALOR1, 0xFF00
    .equ VALOR2, 0x00FF


    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Direccion de los LEDs
    li s0, LEDS_ADDR

    #-- Sacar el valor 1 por los LEDs
    li t0, VALOR1
    sw t0, (s0)

    la a0, _500ms
 loop:
     beq a0,zero, test
     addi a0, a0, -1
     j loop

test:
    li t0, VALOR2
    sw t0, (s0)

    halt

#     li a0, 0xffffff
#  loop:
#     beq a0,zero, 2f
#     addi a0, a0, -1
#     j loop


#     li t0, VALOR2
#     sw t0, (s0)


#     #-- Pausa
#     li a0, _1s
#     jal delay

#     #-- STOP!
#     halt

# #--------------------------
# #-- Subrutina de delay
# #-- Espera de 1seg
# #-- Entradas:
# #--   a0: Pausa
# #--------------------------
# delay:

#     #-- Loop
#  1:
#     beq a0,zero, 2f
#     addi a0, a0, -1
#     j 1b

#     #-- Condicion de salida
#  2:
#     ret

