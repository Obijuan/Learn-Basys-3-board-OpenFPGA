#──────────────────────────────────────────────────────
#──  Copiar una cadena fuente a otra destino
#──
#──  ENTRADAS:
#──    a0: Direccion cadena fuente (src)
#──    a1: Direccion cadena destino (dst)
#──────────────────────────────────────────────────────
    .global strcpy
strcpy:

1:
    #-- Leer byte fuente
    lb t0, 0(a0)

    #-- Copiar a byte destino
    sb t0, 0(a1)

    #-- Si estamos al final, terminar
    beq t0, zero, fin

    #-- Apuntar a los siguientes caracteres
    #-- en cadena fuente y destino
    addi a0, a0, 1
    addi a1, a1, 1

    #-- Repetir
    j 1b

fin:

    ret

#──────────────────────────────────────────────────────
#──  Eliminar los 0s iniciales de la cadena
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
    beq t0, zero, 2f

    #-- Si se alcanza un caracter diferente a '0'
    #-- terminar
    li t1, '0'
    bne t0, t1, 2f

    #-- Pasar al siguiente caracter
    addi a0, a0, 1

    #-- Repetir
    j 1b

    #-- Fin
2:  #-- Devolver el puntero
    ret

