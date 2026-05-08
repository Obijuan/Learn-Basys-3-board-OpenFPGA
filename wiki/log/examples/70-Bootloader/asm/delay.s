#--------------------------
#-- Subrutina de delay
#-- Entradas:
#--   a0: Pausa
#--------------------------
    .global delay
delay:

    #-- Loop
 loop:
    beq a0,zero, fin
    addi a0, a0, -1
    j loop

    #-- Condicion de salida
 fin:
    ret
