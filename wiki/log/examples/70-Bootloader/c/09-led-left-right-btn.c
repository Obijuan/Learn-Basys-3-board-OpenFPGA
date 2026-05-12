//──────────────────────────────────────────────────────
//──  Movimiento de un LED de izquierda a derecha
//──  con las teclas LEFT y RIGHT
//──────────────────────────────────────────────────────
#include <peripherals.h>
#include <buttons.h>

void main()
{
    //-- Inicializar el modulo de los pulsadores
    buttons_init();

    //-- Partícula
    uint16_t particle = 0x100;

    //-- Bucle principal
    while (1) {

        //-- Visualizar partícula
        LEDS = particle;

        //-- Leer pulsadores
        int btns = read_buttons();

        //-- Boton izquierdo apretado
        if (btns & BTN_LEFT) {

            //-- Desplazar particula a la izquierda
            //-- Si no está en el extremo izquierdo
            if (particle != 0x8000)
                particle = particle << 1;
        }

        //-- Boton derecho apretado
        if (btns & BTN_RIGHT) {

            //-- Desplazar particula a la derecha
            if (particle != 0x0001)
                particle = particle >> 1;
        }
    }
}
