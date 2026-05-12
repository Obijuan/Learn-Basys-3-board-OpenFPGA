//──────────────────────────────────────────────────────
//──  Secuencia 1: Secuencia de 2 estados
//──────────────────────────────────────────────────────
#include <peripherals.h>
#include <delay.h>

//-- Valores de la secuencia
#define VALOR1 0xAAAA
#define VALOR2 0x5555

//-- Pausa entre valores
#define PAUSA _250ms

void main()
{

    uint16_t sec[] = {VALOR1, VALOR2};

    //-- Bucle infinito
    while (1) {

        //-- Establecer valor 1
        LEDS = VALOR1;

        //-- Esperar
        delay(PAUSA);

        //-- Establecer valor 2
        LEDS = VALOR2;

        //-- Esperar
        delay(PAUSA);
    }
}

