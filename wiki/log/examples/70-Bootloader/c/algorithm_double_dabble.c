#include <stdint.h>
#include <uart.h>

//-- Buffer para usar con el algoritmo double_dabble
//-- buffer[2]: parte alta
//-- buffer[1]: parte media
//-- buffer[0]: Parte baja: Numero a convertir
uint32_t buffer[3];


//-- Desplazar el buffer un bit a la izquierda
void algorithm_dd_shift1()
{
    //-- Desplazar el buffer 1 bit a la izquierda
    buffer[0] = buffer[0] << 1;
    buffer[0] = buffer[0] | (buffer[1] >> 31);

    buffer[1] = buffer[1] << 1;
    buffer[1] = buffer[1] | (buffer[2] >> 31);

    buffer[2] = buffer[2] << 1;
}

//-- Aplicar un paso del algoritmo al numero
//-- Se pasa el indice al buffer a actualizar
void algorithm_dd_step(int idx)
{
    int bcd;
    int pos;
    uint32_t mask;

    //-- Recorrer los 8 digitos bcd
    for (int i=7; i>=0; i--) {

        //-- Posicion del digito (en bits)
        pos = i << 2;  //(i * 4)

        //-- Mascara para seleccionar el digito actual
        mask = 0xF << pos;

        //-- Obtener digito bcd actual
        bcd = (buffer[idx] & mask) >> pos;

        //-- Actualizar digito
        //-- Si dig > 4, dig = dig + 3
        if (bcd > 4)
            bcd = bcd + 3;

        //-- Colocar digito en su posicion
        buffer[idx] = (buffer[idx] & ~mask) | (bcd << pos);
    }
}


void algorithm_dd_init(uint32_t num)
{
    //-- Inicializar el buffer
    buffer[0] = 0;
    buffer[1] = 0;
    buffer[2] = num;
}

uint64_t algorithm_dd_get_result()
{
    //-- Buffer[0] contiene 2 digitos bcd
    //-- Buffer[1] contiene 8 digitos bcd
    return (uint64_t)buffer[0]<<32 | buffer[1];
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
