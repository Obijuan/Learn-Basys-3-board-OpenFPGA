#──────────────────────────────────────────────────────
#──    BIBLIOTECA de E/S a alto nivel
#──────────────────────────────────────────────────────
    .include "stack.h"

#--------------------------------------------------
#-- puts(cad): Imprimir una cadena en la consola
#--
#-- ENTRADA:
#--   - a0 (cad): Puntero a la cadena a imprimir
#-------------------------------------------------
    .global puts
puts:
    
    #-- Crear la pila y guardar la direccion de retorno
    STACK16
    
    #-- Guardar s0
    sw s0, 0(sp)
    
    #-- s0: Puntero a la cadena
    mv s0, a0
    
  puts_next:
    #-- Leer caracter de la memoria
    lb a0, 0(s0)
    
    #-- Si el caracter es '\0', terminar
    beq a0, zero, puts_end
    
    #-- Imprimir caracter actual
    jal putchar
    
    #-- Apuntar al siguiente caracter
    addi s0, s0, 1
    
    #-- Repetir
    j puts_next


  puts_end:
	#-- Recuperar s0
	lw s0, 0(sp)
	
	#-- Recuperar direccion de retorno y liberar pila
    UNSTACK16


#──────────────────────────────────────────────────────
#──  Imprimir un numero en binario, de 4 bits
#──  En un buffer de memoria
#──
#──  ENTRADAS:
#──    a0: Buffer donde imprimir
#──    a1: Numero a imprimir en binario
#──    a2: Tamaño del numero binario (en bits)
#──    a3: Eliminar 0s iniciales (0=No, 1=si)
#── 
#──  SALIDAS:
#──    a0: Direccion donde comienza la cadena
#──────────────────────────────────────────────────────
  .global sprint_bin
sprint_bin:
    STACK16

    #-- Guardar los parametros
    sw a0, 0(sp)  #-- Buffer
    sw a2, 4(sp)  #-- Tamaño del numero
    sw a3, 8(sp)  #-- Espacios iniciales

    #-- Convertir a array bcd
    #-- Guardarlo en un buffer interno
    la a0, __buff
    jal bin_to_bcd_array

    #-- Convertir a cadena
    la a0, __buff
    lw a1, 4(sp)  #-- Tamaño
    jal bcd_array_to_string

    #-- Comprobar si hay que eliminar ceros iniciales o no
    lw a3, 8(sp)
    beq a3, zero, no_remove_ceros

    #-- Hay que eliminar los 0s
    la a0, __buff
    jal str_remove_leading_zeros

    #-- a0: cadena sin ceros
    j cont
    
no_remove_ceros:
    #-- Seleccionar cadena desde el principio
    la a0, __buff

cont:

    #-- Copiar el numero-cadena en el buffer de la cadena
    #-- La cadena origen a0 contiene bien el numero completo
    #-- o bien apunta al numero sin 0s iniciales
    lw a1, 0(sp)  #-- buffer destino
    jal strcpy

1:
    UNSTACK16


#──────────────────────────────────────────────────────
#──  Imprimir un numero en binario, de 4 bits
#──
#──  ENTRADAS:
#──    a0: Numero a imprimir en binario
#──    a1: Tamaño del numero (en bits)
#──    a2: Eliminar 0s iniciales (0=No, 1=si)
#── 
#──────────────────────────────────────────────────────
  .global print_bin
print_bin:

    STACK16

    #-- La impresion se hace en 2 fase:
    #-- Fase 1: Imprimir el numero en un buffer interno
    mv a3, a2
    mv a2, a1
    mv a1, a0
    la a0, __sprint_buffer
    jal sprint_bin

    #-- Fase 2: Imprimir el buffer en la consola
    la a0, __sprint_buffer
    jal puts

    UNSTACK16



       .data

#-- Buffer para instrucciones sprint
__sprint_buffer: .space 255

#-- Buffer interno para la impresion de numeros
__buff: .space 33
