//──────────────────────────────────────────────────────
//──  Mostrar 2 valores en los LEDs
//──  Valor 1 --> Pausa --> Valor 2 ---> HALT
//──────────────────────────────────────────────────────
#include <peripherals.h>
#include <delay.h>

//-- Valores para la secuencia
#define VALOR1 0xFF00
#define VALOR2 0x00FF

//-- Pausa entre valores
#define PAUSA _500ms

void main()
{
    //-- Bucle infinito
    while (1) {

        //-- Sacar el valor 1 por los LEDs
        LEDS = VALOR1;
        delay(PAUSA);

        //-- Sacar el valor 2 por los LEDs
        LEDS = VALOR2;
        delay(PAUSA);
    }
}

