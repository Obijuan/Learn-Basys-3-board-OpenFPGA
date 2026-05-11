#──────────────────────────────────────────────────────
#──  Cronometro en display de 7 segmentos, con 
#──  temporizador
#──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"

#-- El valor real es 2500000
#-- Pero se ha ajustado empíricamente para que "mas o menos"
#-- dure 100ms
.equ TIMER_100ms, 2200000


.global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Apagar los LEDs
    sw zero, 0(s0)

    #-- Contador de decimas
    li s1, 0

 main_loop:

    #-- Mostrar contador en el display de 7 segm
    mv a0, s1
    jal disp_hex4

    #------- MOSTRAR los puntos
    #-- Mascara de puntos
    li t0, 0x80008000
    or a0, a0, t0
    li t0, SEGMENTS_ADDR
    sw a0, 0(t0)

    #-- Esperar 100ms
    li a0, TIMER_100ms
    jal timer_delay

    #-- Incrementar contador
    addi s1, s1, 1

    #-- Comprobar digito 0 (decimas)
    andi t0, s1, 0xF

    #-- Repite mientras no se alcance el 10
    li t1, 10
    bne t0, t1, main_loop

    #-- Poner a 0 el digito de menor peso
    li t1, 0xF
    not t1, t1
    and s1, s1, t1

    #-- Incrementar los segundos
    addi s1, s1, 0x10

    #-- Obtener digito 1 (segundos)
    srli t1, s1, 4
    andi t1,t1,0xF
    li t0, 10
    bne t1, t0, main_loop

    #-- Poner a 0 los digitos 1 y 0
    li t1, 0xff
    not t1, t1
    and s1, s1, t1

    #-- Incrementar decenas de segundo
    addi s1, s1, 0x100

    #-- Obtener digito 2 (decimas de segundo)
    srli t1, s1, 8
    andi t1, t1, 0xF
    li t0, 6
    bne t1, t0, main_loop
    
    #-- Poner a 0 los digitos 2, 1 y 0
    li t1, 0xFFF
    not t1, t1
    and s1, s1, t1

    #-- Incrementar minutos
    li t0, 0x1000
    add s1, s1, t0

    #-- Obtener digito 3 (minutos)
    srli t1, s1, 12
    andi t1, t1, 0xF
    li t0, 10
    bne t1, t0, main_loop

    #-- Poner a cero el cronometro
    li s1, 0


    #-- Repetir
    j main_loop

    halt



timer_delay:
    #-- Poner los ciclos a 0
    csrw mcycle, zero
    
    #-- Bucle de espera
 wait:
    #-- Leer ciclos
    csrr t0, mcycle

    #-- Calcular tiempo restante
    sub t1, a0, t0

    #-- Repetir si ha transcurrido el tiempo
    bgt t1, zero, wait

    ret




