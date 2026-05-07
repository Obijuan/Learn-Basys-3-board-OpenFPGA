# Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
# Embedded Architectures & Systems Group, Graz University of Technology
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------
# File: ops.s
#
# ------------------------------------------------------------------------------------------------
# |                                                                                              |
# | General instruction test.                                                                    |
# | If everything runs correctly, the first register of the peripheral test module               |
# | should always be zero, except during the first test, which checks the assert macro itself.   |
# | Note: This condition is necessary, but not sufficient to prove coreectness.                  |
# |                                                                                              |
# | Register allocation:                                                                         |
# |     x0  (zero): hardwired 0                                                                  |
# |     x5  (t0):   reserved for macro use                                                       |
# |     x6  (t1):   constant 1                                                                   |
# |     x7  (t2):   test case number                                                             |
# |     x28 (t3):   constant 0x120000<<2 (test peripheral address)                               |
# |     x29 (t4):   constant address of var                                                      |
# |     x30 (t5):   temporary register                                                           |
# |     x31 (t6):   temporary register                                                           |
# |     x21 (s5):   temporary register for interrupt                                             |
# |     x22 (s6):   temporary register for interrupt                                             |
# |                                                                                              |
# ------------------------------------------------------------------------------------------------

.include "stack.h"
.include "delay.h"

#-- Pausa a realizar en secuencia leds
.equ PAUSA, _50ms


.macro pass
    sw zero, 0(t3)
.endm

.macro fail
    sw t1, 0(t3)
.endm

.macro halt
    addi t0, zero, 2
    sw   t0, 0(t3)
.endm

.macro interrupt delay=1
    lui  t0,     %hi(\delay)
    addi t0, t0, %lo(\delay)
    sw   t0, 4(t3)
.endm

.macro assert_equal r1:req, r2:req
    sub  t0, \r1, \r2
    sltu t0, zero, t0
    sw   t0, 0(t3)
.endm

.macro assert_value reg:req, value: req
    lui  t0,     %hi(\value)
    addi t0, t0, %lo(\value)
    assert_equal t0, \reg
.endm

.macro flush_pipeline
    nop
    nop
    nop
    nop
    nop
.endm

#-- Direccion de los LEDs
.equ LEDS, 0x200000

# ------------------------------------------------------------------------------------------------
# |                                          Test entry!                                         |
# ------------------------------------------------------------------------------------------------
.global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- gp -> Direccion de los leds
    li gp, LEDS

    #-- Contador de errores
    li s11, 0


test_init:
    addi t1, zero, 1              # t1 = 1 (x6=1)
    addi t2, zero, 0              # t2 = test case number (x7=1)
    lui  t3, %hi(0x120000<<2)     # t3 = peripheral test address (x28)
    lui  t4, %hi(var)             # t4 = variable address (x29)
    flush_pipeline
    addi t3, t3, %lo(0x120000<<2)
    addi t4, t4, %lo(var)

test_fail:
    addi t2, zero, 1
    assert_value zero, 1

    #-- Actualizar contador de errores
    #-- t0 = 0 --> test ok
    #-- t0 = 1 --> Test fallado
    add s11, s11, t0

    #-- Hay más de 1 error...
    bgt s11, t1, error
   

# ------------------------------------------------------------------------------------------------
# |                                          Test done!                                          |
# ------------------------------------------------------------------------------------------------
test_finish:
    addi t2, zero, 57
    halt
    fail

 1:
    li a0, 0x01  #-- Valor inicial seq
    li a1, 0x01  #-- Bits a desplazar a la izq
    li a2, 16    #-- Numero de pasos
    jal play1
    j 1b

# --- Error en algun test
error:

    #-- Mostrar numero de test en los leds
    sw t2, (gp)
    j .


    .align 4
var:
    .word 0xcafebabe

#----- Dependencias
.include "delay.s"
.include "seq.s"
