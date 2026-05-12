//──────────────────────────────────────────────────────
//──  MODULO DE ACCESO A LOS PULSADORES
//──────────────────────────────────────────────────────
#include <stdint.h>
#include <peripherals.h> 

//──────────────────────────────────────────────────────
//──  Variables internas del modulo
//──────────────────────────────────────────────────────
//-- Estado de los pulsadores de cambio
uint8_t toggle_state = 0;

//-- Valor anterior de los pulsadores
uint8_t old_value = 0;


//──────────────────────────────────────────────────────
//──  Inicializacion del modulo de pulsadores
//──────────────────────────────────────────────────────
void buttons_init()
{
    //-- Poner a 0 las variables
    toggle_state = 0;
    old_value = 0;
}


//──────────────────────────────────────────────────────
//──  Lectura de los pulsadores
//──  Lectura NO BLOQUEANTE
//──  
//──  DEVUELVE:
//──    * Mascara con los pulsadores apretados (tic)
//──────────────────────────────────────────────────────
int read_buttons()
{

    //-- Leer el valor actual de los pulsadores
    int value = BUTTONS;

    //-- Detectar cambio en pulsadores
    int change = value ^ old_value;
    
    //-- Quedarse solo con los que ha sido presionados
    int press = change & value;

    //-- Guardar el estado actual
    old_value = value;

    //-- Devolver pulsadores apretados
    return press;
}


//──────────────────────────────────────────────────────
//──  Pulsadores de CAMBIO
//──  Lectura NO BLOQUEANTE
//──  
//──  DEVUELVE:
//──    * Estado de los pulsadores de cambio
//──────────────────────────────────────────────────────
int toggle_btn()
{
    uint8_t btns;

    //-- Leer si hay botones presionados
    btns = read_buttons();

    //-- Cambiar estado de los pulsadores
    toggle_state = toggle_state ^ btns;

    //-- Devolver botones de cambio
    return toggle_state & 0x1F;

}
