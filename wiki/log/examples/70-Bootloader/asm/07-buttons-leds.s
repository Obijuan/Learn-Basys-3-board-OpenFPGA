 #──────────────────────────────────────────────────────
 #──  Mostrar el estado de los pulsadores en los LEDs
 #──────────────────────────────────────────────────────
 
   .include "peripherals.h"
   .include "so.h"


   .global __reset
__reset:

   #-- Inicializar la pila
   la sp, __ram_end

   #-- s0: Direccion de los LEDs
   li s0, LEDS_ADDR

   #-- s1: Direccion de los pulsadores
   li s1, BUTTONS_ADDRESS

   #--- Bucle principal
 main_loop:
   
   #-- Leer pulsadores
   lw t0, 0(s1)

   #-- Se encuentran en los bits 4 - 0
   #-- Moverlos a los bits 15 - 11
   slli t0, t0, 11

   #-- Mostrar su estado en los LEDs
   sw t0, 0(s0)

   #-- Repetir!
   j main_loop




