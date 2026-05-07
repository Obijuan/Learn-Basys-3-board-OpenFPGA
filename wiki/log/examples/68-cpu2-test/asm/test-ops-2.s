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

    #-- Actualizar contador de errores
    #-- t0 = 0 --> test ok
    #-- t0 = 1 --> Test fallado
    add s11, s11, t0

    #-- Hay más de 1 error...
    bgt s11, t1, error
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

# -----------------------------------------------
# LUI ✅
test_lui:
    addi t2, zero, 2
    flush_pipeline
    lui  t6, %hi(0x12345678)
    assert_value t6, 0x12345000

# -----------------------------------------------
# AUIPC ✅
test_auipc:
    addi  t2, zero, 3
    flush_pipeline
    auipc t6, %hi(0x12345678)
    auipc t5, %hi(0x12345678)
    sub   t6, t5, t6
    assert_value t6, 4

# -----------------------------------------------
# JAL ✅  
test_jal:
    addi  t2, zero, 4
    flush_pipeline
    auipc t6, 0
    jal   t5, jal_target
    fail

    jal_target:
    sub t6, t5, t6
    addi x0, t6, 0

    assert_value t6, 8

# -----------------------------------------------
# JALR  ✅
test_jalr:
    addi  t2, zero, 5
    flush_pipeline
    auipc t6, 0
    lui   t5, %hi(jalr_target)
    jalr  t5, %lo(jalr_target)(t5)
    fail

    jalr_target:
    sub t6, t5, t6
    assert_value t6, 12

# -----------------------------------------------
# BRANCH 
test_beq: # ✅
    addi t2, zero, 6
    flush_pipeline
    beq  zero, t1,   beq_target_fail
    beq  zero, zero, beq_target
    beq_target_fail:
    fail
    beq_target:

test_bne: # ✅
    addi t2, zero, 7
    flush_pipeline
    bne  zero, zero, bne_target_fail
    bne  zero, t1,   bne_target
    bne_target_fail:
    fail
    bne_target:

test_blt: # ✅
    addi t2, zero, 8
    flush_pipeline
    blt  t1, zero, blt_target_fail
    blt  zero, t1, blt_target
    blt_target_fail:
    fail
    blt_target:

test_bge: # ✅
    addi t2, zero, 9
    bge  zero, t1, bge_target_fail
    bge  t1, zero, bge_target
    bge_target_fail:
    fail
    bge_target:

test_bltu: # ✅
    addi t2, zero, 10
    flush_pipeline
    addi t6, zero, -1
    bltu t6, zero, bltu_target_fail
    bltu zero, t6, bltu_target
    bltu_target_fail:
    fail
    bltu_target:

test_bgeu: # ✅ 
    addi t2, zero, 11
    flush_pipeline
    addi t6, zero, -1
    bgeu zero, t6, bgeu_target_fail
    bgeu t6, zero, bgeu_target
    bgeu_target_fail:
    fail
    bgeu_target:

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
