#──────────────────────────────────────────────────────
#──  Copiar una cadena fuente a otra destino
#──
#──  ENTRADAS:
#──    a0: Direccion cadena fuente (src)
#──    a1: Direccion cadena destino (dst)
#──
#──  SALIDA:
#──    a0: Direccion del final de la cadena destino
#──────────────────────────────────────────────────────
    .global strcpy
strcpy:

1:
    #-- Leer byte fuente
    lb t0, 0(a0)

    #-- Copiar a byte destino
    sb t0, 0(a1)

    #-- Si estamos al final, terminar
    beq t0, zero, 2f

    #-- Apuntar a los siguientes caracteres
    #-- en cadena fuente y destino
    addi a0, a0, 1
    addi a1, a1, 1

    #-- Repetir
    j 1b

    #-- Fin
2:
    #-- Devolver la dirección del final de la cadena destino
    mv a0, a1
    ret


#──────────────────────────────────────────────────────
#──  Eliminar los 0s iniciales de la cadena
#──  Salvo si solo hay 1
#──
#──  Ej. "00012" ---> "12"
#──  Ej. "00000" ---> "0"
#──
#──  ENTRADAS:
#──    a0: Direccion cadena
#── 
#──  SALIDAS:
#──    a0: Direccion donde comienza la cadena sin 
#──        los ceros
#──────────────────────────────────────────────────────
    .global str_remove_leading_zeros
str_remove_leading_zeros:

1:
    #-- Leer caracter
    lb t0, 0(a0)

    #-- Hemos llegado al final
    beq t0, zero, 3f

    #-- Se alcanza un caracter diferente a '0'
    #-- hay que terminar, sin hacer nada mas
    li t1, '0'
    bne t0, t1, str_remove_leading_zeros_end

    #-- Es un '0'
    #-- Pasar al siguiente caracter
    addi a0, a0, 1

    #-- Repetir
    j 1b

    #-- Hay al menos un caracter diferente a '0' 
2:  #-- Comprobar si habia 0's iniciales

    #-- Fin
3:  #-- Se ha llegado al final de la cadena y NO hay caracteres
    #-- diferentes a '0'. TODOS son '0'
    #-- Apuntar al último '0'
    addi a0, a0, -1

str_remove_leading_zeros_end:
    #-- Devolver el puntero
    ret



#──────────────────────────────────────────────────────
#──  Convertir un array de numeros BCD a una cadena
#──  Cada numero bcd se almacena en un byte de memoria
#──
#──  ENTRADAS:
#──    a0: Direccion donde comienzan los digitos bcd
#──    a1: Tamaño en bytes del array de digitos
#── 
#──  SALIDAS:
#──    a0: Puntero al final de la cadena generada
#──        (esto permite concatenarlas)
#──────────────────────────────────────────────────────
    .global bcd_array_to_string
bcd_array_to_string:

loop:
    #-- Si el tamaño es 0, terminar
    beq a1, zero, 1f

    #-- Leer el numero bcd
    #-- t0: numero bcd
    lb t0, 0(a0)

    #-- Convertir de bcd a caracter
    li t1, 9
    bgt t0, t1, hexa

    #-- t0 <=9 --> Sumar '0'
    addi t0, t0, '0'
    j cont

    #-- t0 > 10 --> Sumar 'A'-10
hexa:
    addi t0, t0, 'A'-10

cont:
    #-- Almacenar caracter en la posicion actual
    sb t0, 0(a0)

    #-- Queda un caracter menos
    addi a1, a1, -1
    
    #-- Apuntar al siguiente
    addi a0, a0, 1

    #-- Repetir
    j loop

    #-- Fin
1:  sb zero, 0(a0)
    ret

