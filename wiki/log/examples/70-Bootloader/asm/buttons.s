    .include "peripherals.h"


#------------------------------------------------
#-- Lectura de los pulsadores
#--
#-- SALIDA:
#--   a0: Pulsadores que se han presionado (tic)
#------------------------------------------------
  .global read_buttons
read_buttons:

    #-- t0: Direccion de los pulsadores
    li t0, BUTTONS_ADDRESS

    #-- t1: Direccion de la variable: btn_state
    la t1, btn_state

    #-- Leer Estado actual de los botones
    #-- t2: Estado actual
    lw t2, 0(t0)

    #-- Leer estado anterior de los botones
    #-- t3: Estado anterior
    lw t3, 0(t1)

    #-- Detectar cambio en pulsadores
    #-- t4: Cambio en pulsadores
    xor t4, t3, t2

    #-- Detectar presion de tecla
    and t5, t4, t2

    #-- Guardar el estado actual de los pulsadores
    sw t2, 0(t1)

    #-- Devolver las teclas presionadas
    mv a0, t5

    #-- terminar
    ret


    .data

#-- Estado anterior de los pulsadores
btn_state: .word 0x0000



#-------------------------------------------------------------
#-- Lectura de los botones de cambio
#--
#-- Se actualiza su estado en funcion de los pulsadores
#-- y se devuelve su valor listo para usarse
#--
#--  SALIDAS:
#--    a0: Estado de los pulsadores de cambio
#-------------------------------------------------------------
  .text
  .global toggle_btn
toggle_btn:

   #-- Direcciones
   #--  t0: Variable btn_state
   #--  t1: Pulsadores
   la t0, btn_state2
   li t1, BUTTONS_ADDRESS

   #-- Leer el estado anterior de los botones
   #-- t2: Estado anterior
   lw t2, 0(t0)

   #-- Leer el estado actual
   #-- t3: Estado actual
   lw t3, 0(t1)

   #-- Detectar si ha habido pulsación, comparando el estado
   #-- anterior con el actual
   #-- t4: Pulsadores que han cambiado (presion o liberacion)
   xor t4, t2, t3
   beq t4, zero, no_change

   #-- Ha habido cambio!
   #-- Solo nos fijamos en el cambio 0 -> 1: Presion!
   #-- t5 contiene los pulsadores apretados (tic)
   and t5, t4, t3

   #-- t6: Botones de cambio
   lw t6, 4(t0)

   #-- Modificar los botones de cambio que corresponda
   xor t6, t6, t5

   #-- Guardar botones de cambio
   sw t6, 4(t0)

 no_change:

   #-- Guardar el estado actual de los pulsadores
   sw t3, 0(t0)

   #-- Devolver los botones de cambio
   mv a0, t6

   #-- Terminar
   ret



   .data

#-- Estado anterior de los pulsadores
btn_state2:    .word 0x0000

#-- Estado de los botones de cambio
toggle_state: .word 0x0000
