//──────────────────────────────────────────────────────
//──  BIBLIOTECA DEL TEMPORIZADOR
//──────────────────────────────────────────────────────
#include <stdint.h>

//──────────────────────────────────────────────────────
//──  Retraso usando el temporizador
//──  
//──  ENTRADA:
//──    cycle: Ciclos de espera
//──────────────────────────────────────────────────────
void timer_delay(uint32_t cycles) 
{
    uint32_t ciclos;

    //-- Poner los ciclos a 0
    asm("csrw mcycle, zero");

    do {
        //-- Leer los ciclos
        asm volatile ("csrr %0, mcycle" : "=r" (ciclos));

    } while (ciclos < cycles);

}
// timer_delay:
//     #-- Poner los ciclos a 0
//     csrw mcycle, zero
    
//     #-- Bucle de espera
//  wait:
//     #-- Leer ciclos
//     csrr t0, mcycle

//     #-- Calcular tiempo restante
//     sub t1, a0, t0

//     #-- Repetir si ha transcurrido el tiempo
//     bgt t1, zero, wait

//     ret
