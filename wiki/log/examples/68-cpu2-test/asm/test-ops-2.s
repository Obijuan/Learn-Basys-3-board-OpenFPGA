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

# -----------------------------------------------
# LOAD
test_lb:  # ✅
    addi t2, zero, 12
    flush_pipeline
    lb   t6, 0(t4)
    assert_value t6, 0xffffffbe
    lb   t6, 1(t4)
    assert_value t6, 0xffffffba
    lb   t6, 2(t4)
    assert_value t6, 0xfffffffe
    lb   t6, 3(t4)
    assert_value t6, 0xffffffca

test_lh: # ✅
    addi t2, zero, 13
    flush_pipeline
    lh   t6, 0(t4)
    assert_value t6, 0xffffbabe
    lh   t6, 2(t4)
    assert_value t6, 0xffffcafe

test_lw: # ✅
    addi t2, zero, 14
    flush_pipeline
    lw   t6, 0(t4)
    assert_value t6, 0xcafebabe

test_lbu: # ✅
    addi t2, zero, 15
    flush_pipeline
    lbu  t6, 0(t4)
    assert_value t6, 0x000000be
    lbu  t6, 1(t4)
    assert_value t6, 0x000000ba
    lbu  t6, 2(t4)
    assert_value t6, 0x000000fe
    lbu  t6, 3(t4)
    assert_value t6, 0x000000ca

test_lhu: # ✅
    addi t2, zero, 16
    flush_pipeline
    lhu  t6, 0(t4)
    assert_value t6, 0x0000babe
    lhu  t6, 2(t4)
    assert_value t6, 0x0000cafe

# -----------------------------------------------
# STORE
test_sb: # ✅
    addi t2, zero, 17
    flush_pipeline
    lui  t5,     %hi(0xdeadbeef)
    addi t5, t5, %lo(0xdeadbeef)
    sb   t5, 0(t4)
    lw   t6, 0(t4)
    assert_value t6, 0xcafebaef

test_sh: # ✅
    addi t2, zero, 18
    flush_pipeline
    sh   t5, 0(t4)
    lw   t6, 0(t4)
    assert_value t6, 0xcafebeef

test_sw: # ✅
    addi t2, zero, 19
    flush_pipeline
    sw   t5, 0(t4)
    lw   t6, 0(t4)
    assert_value t6, 0xdeadbeef

# -----------------------------------------------
# IMMEDIATE
test_addi:  # ✅
    addi t2, zero, 20
    flush_pipeline
    addi t6, zero, 0x123
    addi t6, t6,   0x456
    assert_value t6, (0x123 + 0x456)

test_slti: # ✅
    addi t2, zero, 21
    flush_pipeline
    slti t6, zero, -1
    assert_value t6, 0
    slti t6, zero, +1
    assert_value t6, 1

test_sltiu: # ⬅️
    addi  t2, zero, 22
    flush_pipeline
    sltiu t6, zero, -1
    assert_value t6, 1
    sltiu t6, zero, +1
    assert_value t6, 1

test_xori:
    addi t2, zero, 23
    flush_pipeline
    addi t6, zero, 0x321
    xori t6, t6,   0x789
    assert_value t6, (0x321 ^ 0x789)

test_ori:
    addi t2, zero, 24
    flush_pipeline
    addi t6, zero, 0x321
    ori  t6, t6,   0x789
    assert_value t6, (0x321 | 0x789)

test_andi:
    addi t2, zero, 25
    flush_pipeline
    addi t6, zero, 0x321
    andi t6, t6,   0x789
    assert_value t6, (0x321 & 0x789)

test_slli:
    addi t2, zero, 26
    flush_pipeline
    addi t6, zero, -16 # 0b1...10000
    slli t6, t6,   4
    assert_value t6, 0xffffff00

test_srli:
    addi t2, zero, 27
    flush_pipeline
    addi t6, zero, -16
    srli t6, t6,   4
    assert_value t6, 0x0fffffff

test_srai:
    addi t2, zero, 28
    flush_pipeline
    addi t6, zero, -16
    srai t6, t6,   4
    assert_value t6, 0xffffffff

# -----------------------------------------------
# ALU
init_alu_regs:
    flush_pipeline
    addi t5, zero, 6
    addi t6, zero, -0x123
    flush_pipeline

test_add:
    addi t2, zero, 29
    flush_pipeline
    add  s6, t6, t5
    assert_value s6, (-0x123 + 6)

test_sub:
    addi t2, zero, 30
    flush_pipeline
    sub s6, t6, t5
    assert_value s6, (-0x123 - 6)

test_sll:
    addi t2, zero, 31
    flush_pipeline
    sll s6, t6, t5
    assert_value s6, 0xffffb740 # -0x123 <<< 6

test_slt:
    addi t2, zero, 32
    flush_pipeline
    slt s6, t5, t6
    assert_value s6, 0
    slt s6, t6, t5
    assert_value s6, 1

test_sltu:
    addi t2, zero, 33
    flush_pipeline
    sltu s6, t6, t5
    assert_value s6, 0
    sltu s6, t5, t6
    assert_value s6, 1

test_xor:
    addi t2, zero, 34
    flush_pipeline
    xor s6, t6, t5
    assert_value s6, (-0x123 ^ 6)

test_srl:
    addi t2, zero, 35
    flush_pipeline
    srl s6, t6, t5
    assert_value s6, 0x03fffffb # -0x123 >>> 6

test_sra:
    addi t2, zero, 36
    flush_pipeline
    sra s6, t6, t5
    assert_value s6, 0xfffffffb # -0x123 >> 6

test_or:
    addi t2, zero, 37
    flush_pipeline
    or s6, t6, t5
    assert_value s6,  (-0x123 | 6)

test_and:
    addi t2, zero, 38
    flush_pipeline
    and s6, t6, t5
    assert_value s6,  (-0x123 & 6)

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
