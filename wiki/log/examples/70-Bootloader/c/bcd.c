#include <stdint.h>
#include "algorithm_double_dabble.h"

//──────────────────────────────────────────────────────
//──  Convertir un numero bcd a ASCII
//──────────────────────────────────────────────────────
char bcd_to_ascii(int bcd)
{
    if (bcd < 10)
        return bcd + '0';
    else 
        return bcd + ('A' - 10);
}

//-- Convertir un numero entero de 32bits a sus 10 digitos bcd
uint64_t uint_to_bcd(uint32_t num)
{
    //-- Inicializar algoritmo
    algorithm_dd_init(num);

    //-- Desplazar el buffer 3 bits a la izquierda
    for (int i=0; i<3; i++) {
        algorithm_dd_shift1();
    }

    //-- Bucle principal del algoritmo
    for (int i=0; i<29; i++) {
        //-- Actualizar registro buffer
	    //-- Hay que sumar 3 a cada digito BCD, si es > 4
	    algorithm_dd_step(0);
        algorithm_dd_step(1);

	    //-- Desplazar 1 bit a la izquierda registro buffer
	    //-- buffer << 1
        algorithm_dd_shift1();
    }

    return algorithm_dd_get_result();
}


