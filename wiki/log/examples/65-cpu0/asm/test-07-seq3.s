.macro halt
    j .
.endm


#-- Direccion de los LEDs
.equ LEDS, 0x200000

#-- Valores para las pausas
.equ _100ms, 0x32dcd5
.equ _200ms, _100ms * 2
.equ _250ms, 0x7f2815
.equ _500ms, _250ms * 2
.equ _1s, _250ms * 4

#-- Pausa a realizar
.equ PAUSA, _1s


.global __reset
__reset:

   #-- Inicializar la pila
   li sp, 0x40800

   #-- s0 -> Direccion de los leds
   li s0, LEDS

 main:
   #-- a0: Valor inicial
   li s1, 0x03

   #-- a1: Bits a desplazar a la izquierda
   li s2, 0x02

   #-- a2: Numero de pasos a dar
   li s3, 0x8

 loop:
   
   #-- Mostrar secuencia actual
   sw s1, (s0)

   #-- Esperar
   li a0, _250ms
   jal delay

   #-- Desplazar a la izquierda
   sll s1, s1, s2

   #-- Queda un paso menos
   addi s3, s3, -1
   
   #-- Si quedan pasos, repetir
   bgt s3, zero, loop

   #-- Secuencia terminada
   #-- Repetir
   j main

   #-- STOP
   halt


#--------------------------
#-- Subrutina de delay
#-- Espera de 1seg
#-- Entradas:
#--   a0: Pausa
#--------------------------
delay:

    #-- Loop
 1:
    beq a0,zero, 2f
    addi a0, a0, -1
    j 1b

    #-- Condicion de salida
 2:
    ret
