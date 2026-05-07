#include <stdint.h>

//-- Constantes para el delay
//-- hex(int(0.250 * 25_000_000 / 7))
#define _50ms 0x2b98b
#define _100ms _50ms * 2
#define _200ms _100ms * 2
#define _250ms _200ms + _50ms
#define _500ms _250ms * 2
#define _1s _500ms * 2

//-- Prototipos
void delay(uint32_t wait);

