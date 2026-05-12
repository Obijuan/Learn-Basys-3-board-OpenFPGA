//──────────────────────────────────────────────────────
//──  Secuencia 2: seq1: Desplazamiento a la izquierda
//──────────────────────────────────────────────────────
#include <peripherals.h>
#include <delay.h>

//-- Valor inicial de la secuencia
#define VALOR_INI 0x01

//-- Numero de desplazamientos
#define NSHIFTS 16

//-- Pausa entre valores
#define PAUSA _50ms

void main()
{

    //-- Repetir infinitamente
    while(1) {
        //-- Valor actual de la secuencia
        int value = VALOR_INI;

        //-- Realizar un desplazamiento completo
        for (int i = 0; i<NSHIFTS; i++) {

            //-- Mostrar valor en los LEDs
            LEDS = value;

            //-- Pausa
            delay(PAUSA);

            //-- Desplazar el valor a la izquierda
            value = value << 1;
        }
    }

}

