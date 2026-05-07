#-- Calculo python:
#--- hex(int(0.250 * 25_000_000 / 3))
#-- Valores para las pausas
.equ _50ms,  0x65b9a
.equ _100ms, 0xcb735
.equ _200ms, _100ms * 2
.equ _250ms, 0x1fca05
.equ _500ms, _250ms * 2
.equ _1s, _250ms * 4

#-- Pausa a realizar
.equ PAUSA, _1s

.macro DELAY1S
    li a0, _1s
    jal delay
.endm

.macro DELAY100ms
    li a0, _100ms
    jal delay
.endm
