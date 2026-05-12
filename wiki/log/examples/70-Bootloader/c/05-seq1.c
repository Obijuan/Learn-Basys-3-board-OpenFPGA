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

    //-- Valores de la secuencia a mostrar
    uint16_t seq[] = {VALOR1, VALOR2};
    uint8_t i = 0;

    //-- Bucle infinito
    while (1) {

        //-- Establecer valor actual
        LEDS = seq[i];

        //-- Esperar
        delay(PAUSA);

        //-- Apuntar al siguiente valor
        i = i ^ 1;
    }
}

