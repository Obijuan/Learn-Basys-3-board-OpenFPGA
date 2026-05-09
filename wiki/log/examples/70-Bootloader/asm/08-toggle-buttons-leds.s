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

   #--- Bucle principal
 main_loop:

   #-- Leer pulsadores de cambio  
   jal toggle_btn

   #-- Enviar su estado a los leds
   sw a0, 0(s0)

   #-- Repetir!
   j main_loop



