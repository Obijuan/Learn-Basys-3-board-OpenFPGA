 #──────────────────────────────────────────────────────
 #──  Pulsadores de cambio (toggle button)
 #──  Su estado se muestra en los LEDs
 #──  Con cada pulsacion se cambia el estado del LED
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

   #-- Leer el estado inicial de los pulsadores
   lw t0, 0(s1)

   #-- t3: Estado de los LEDs
   li t3, 0

   #--- Bucle principal
 main_loop:
   
   #-- Leer el estado actual de los pulsadores
   lw t1, 0(s1)

   #-- Detectar si ha habido pulsación, comparando el estado
   #-- anterior con el actual
   xor t2, t0, t1
   beq t2, zero, next

   #-- Ha habido cambio!
   #-- Solo nos fijamos en el cambio 0 -> 1: Pulsación!
   #-- t2 contiene los pulsadores apretados (tic)
   and t2, t2, t1

   #-- Cambiar el estado de los LEDs afectados
   xor t3, t3, t2
   
 next:
   #-- Mostrar estado en los LEDs
   sw t3, 0(s0)

   #-- El estado actual pasa a ser el anterior
   mv t0, t1

   #-- Repetir!
   j main_loop




