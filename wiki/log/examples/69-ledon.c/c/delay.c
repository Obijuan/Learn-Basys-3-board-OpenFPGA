#include <stdint.h>

//-------------------------
//-- DELAY
//-------------------------
void delay(uint32_t wait)
{
    for (uint32_t i=0; i < wait; i++) {
        asm("nop");
    }
}
