#include <stdint.h>

//-- Prototipos
void delay(uint32_t);

//-- Calculo python:
//--- hex(int(0.250 * 25_000_000 / 6))
//-- Valores para las pausas
#define _50ms  0x32dcd
#define _100ms _50ms * 2
#define _200ms _100ms * 2
#define _250ms _50ms * 5
#define _500ms _250ms * 2
#define _1s _250ms * 4




