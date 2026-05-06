#-- Valores para las pausas
#-- Valores magicos calculados a partir de esta ecuacion
#--  Tiempo = ( CiclosPorIteracion ∗ Iteraciones ) / 50 Mhz
#-- La rutina usada tarda 3 ciclos por iteracción y tiene N iteraciones
#-- Tiempo = (3 * N)/50 Mhz --> N = (50_000_000*Tiempo)/3 

#-- Valores para las pausas
#-- Calculo python:
#--- hex(int(0.250 * 50_000_000 / 3))
.equ _50ms,  0xcb735
.equ _100ms, 0x196e6a
.equ _200ms, _100ms * 2
.equ _250ms, 0x3f940a
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
