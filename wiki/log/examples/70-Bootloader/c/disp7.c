//──────────────────────────────────────────────────────
//──    BIBLIOTECA PARA EL DISPLAY DE 7 SEGMENTOS
//──────────────────────────────────────────────────────
#include "peripherals.h"


//-- Tabla de conversion BCD a 7seg
int tabla[] = {
    0x3F,  //-- Digito 0
    0x06,  //-- Digito 1
    0x5B,  //-- Digito 2
    0x4F,  //-- Digito 3
    0x66,  //-- Digito 4
    0x6D,  //-- Digito 5
    0x7D,  //-- Digito 6
    0x07,  //-- Digito 7
    0x7F,  //-- Digito 8
    0x6F,  //-- Digito 9
    0x77,  //-- Digito A
    0x7C,  //-- Digito B
    0x39,  //-- Digito C
    0x5E,  //-- Digito D
    0x79,  //-- Digito E
    0x71   //-- Digito F
};


//──────────────────────────────────────────────────────
//── Convertir un digito bcd a los segmentos de un
//── display
//──
//── ENTRADAS:
//──    Digito bcd
//──
//── SALIDA:
//──    Segmentos (1 byte)
//──────────────────────────────────────────────────────
int bcd2disp(int bcd)
{
    //-- Devolver el valor de la tabla
    return tabla[bcd & 0xF];
}


//──────────────────────────────────────────────────────
//──  Mostrar en el display de 7 segmentos un numero
//──  hexadecimal de 4 digitos
//── 
//──  ENTRADA:
//──    Numero a mostrar
//── 
//──  SALIDA:
//──    Valor para los displays de 7 segmentos (32-bits)
//──────────────────────────────────────────────────────
int disp_hex4(int hex4)
{
    int segments = 0;
    uint8_t segs;

    //-- Recorrer los 4 digitos BCD
    for (int i=0; i<4; i++) {

        //-- Segmentos del digito i
        segs = bcd2disp(hex4 & 0xF);

        //-- Colocar el byte en la posicion i*8
        segments = segments | (segs << (8*i));

        //-- Desplazar hex4 para acceder al siguiente digito
        hex4 = (hex4 >> 4);
    }

    //-- Mostrar numero en el display
    SEGMENTS = segments;

    //-- Devolver el valor calculado
    return segments;
}
