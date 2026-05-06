.macro halt
    j .
.endm


#-- Direccion de los LEDs
.equ LEDS, 0x200000

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
.equ PAUSA, _50ms


.global __reset
__reset:

   #-- Inicializar la pila
   li sp, 0x40800

   #-- s0 -> Direccion de los leds
   li s0, LEDS

 main:
   #-- a0: Valor inicial
   li a0, 0x01

   #-- a1: Bits a desplazar a la izquierda
   li a1, 0x01

   #-- a2: Numero de pasos a dar
   li a2, 16

   jal play1

   #-- Repetir
   j main

 #-------------------------------------------
 #-- play1: Dar una pasada a la secuencia
 #--
 #--  a0: Valor inicial de la secuencia
 #--  a1: Bits a desplazar a la izquierda
 #--  a2: Pasos de la secuencia
 #--
 #------------------------------------------
 play1:
   addi sp, sp, -16
   sw ra, 12(sp)

   #-- Guardar registros estaticos usados
   sw s1, 0(sp)
   sw s2, 4(sp)
   sw s3, 8(sp)

   #-- Leer parametros
   mv s1, a0
   mv s2, a1
   mv s3, a2

 loop:
   
   #-- Mostrar secuencia actual
   sw s1, (s0)

   #-- Esperar
   li a0, PAUSA
   jal delay

   #-- Desplazar a la izquierda
   sll s1, s1, s2

   #-- Queda un paso menos
   addi s3, s3, -1
   
   #-- Si quedan pasos, repetir
   bgt s3, zero, loop

   #-- Secuencia terminada
   #-- Recuperar registros estaticos
   lw s1, 0(sp)
   lw s2, 4(sp)
   lw s3, 8(sp)

   #-- Recuperar direccion de retorno
   lw ra, 12(sp)
   addi sp, sp, 16
   ret


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
