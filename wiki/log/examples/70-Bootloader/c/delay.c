#include <stdint.h>

//──────────────────────────────────────────────────────
//──  Mostrar 2 valores en los LEDs
//──  Valor 1 --> Pausa --> Valor 2 ---> HALT
//──────────────────────────────────────────────────────
void delay(uint32_t ntime)
{
    for (uint32_t i = 0; i<=ntime; i++);
}

