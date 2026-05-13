//──────────────────────────────────────────────────────
//──  Cronometro en display de 7 segmentos, con 
//──  temporizador
//──────────────────────────────────────────────────────
#include <stdint.h>
#include "peripherals.h"
#include "disp7.h"
#include "delay.h"


void main() 
{
    uint16_t contador_bcd = 0;
    uint8_t decimas = 3;
    uint8_t seg_u = 6;
    uint8_t seg_d = 5;
    uint8_t min = 2;
    int segm;

    //-- Apagar los LEDs
    LEDS = 0;

    for (;;) {
        //-- Construir el contador a partir de sus digitos bcd
        contador_bcd = min << 12 | seg_d << 8 | seg_u << 4| decimas;

        //-- Mostrar contador en display
        segm = disp_hex4(contador_bcd);

        //-- Mostrar los puntos
        SEGMENTS = segm | 0x80008000;

        delay(_100ms);

        //---- Incrementar el contador
        //-- Decimas
        decimas++;

        //-- NOTA: NO SE USAN OPERACIONES DE % PARA
        //-- QUE EL CODIGO SEA MAS OPTIMIZADO
        if (decimas == 10) {

            decimas = 0;

            //-- Unidades de Segundos
            //--  seg_u = (seg_u + 1) % 10;
            seg_u++;
            if (seg_u == 10)
                seg_u = 0;
           

            //-- Decenas de segundo
            if (seg_u == 0) {
                //seg_d = (seg_d + 1) % 6;
                seg_d++;
                if (seg_d == 6)
                    seg_d = 0;

                //-- Minutos
                if (seg_d == 0) {
                    //min = (min + 1) % 10;
                    min++;
                    if (min==10)
                        min = 0;
                }

            }
        }
    }
}




