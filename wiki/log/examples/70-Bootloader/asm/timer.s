#──────────────────────────────────────────────────────
#──  BIBLIOTECA DEL TEMPORIZADOR
#──────────────────────────────────────────────────────


#──────────────────────────────────────────────────────
#──  Retraso usando el temporizador
#──  
#──  ENTRADA:
#──    a0: Ciclos de espera
#──────────────────────────────────────────────────────
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

