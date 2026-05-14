#──────────────────────────────────────────────────────
#──    BIBLIOTECA de E/S a alto nivel
#──────────────────────────────────────────────────────
    .include "stack.h"


#──────────────────────────────────────────────────────
#── Imprimir una cadena en un buffer en memoria
#── 
#── ENTRADAS:
#──   * a0: Puntero al buffer donde imprimir
#──   * a1: PUntero a la cadena a imprimir
#──
#── SALIDAS:
#──   * a0: Puntero al final del buffer
#──────────────────────────────────────────────────────
    .global sprint
sprint:
    #-- Crear la pila y guardar la direccion de retorno
    STACK16

    #-- Guardar s0 y s1
    sw s0, 0(sp)
    sw s1, 4(sp)
    
    #-- s0: Puntero al buffer
    mv s0, a0

    #-- s1: Puntero a la cadena
    mv s1, a1

 1:
    #-- Leer caracter de la cadena
    lb a0, 0(s1)

    #-- Escribirlo en el buffer
    sb a0, 0(s0)
    
    #-- Si el caracter es '\0', terminar
    beq a0, zero, sprint_end
    
    #-- Incrementar los punteros
    addi s0, s0, 1
    addi s1, s1, 1
    
    #-- Repetir
    j 1b


  sprint_end:
	#-- Recuperar s0 y s1
	lw s0, 0(sp)
    lw s1, 4(sp)


    #-- Recuperar direccion de retorno y liberar pila
    UNSTACK16


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

    UNSTACK16


#──────────────────────────────────────────────────────
#──  Imprimir un numero en hexadecimal
#──  en un buffer de memoria
#──
#──  ENTRADAS:
#──    a0: Buffer donde imprimir
#──    a1: Numero a imprimir
#──    a2: Tamaño del numero (4,8,16,32)
#──    a3: Eliminar 0s iniciales (0=No, 1=si)
#── 
#──  SALIDAS:
#──    a0: Direccion donde comienza la cadena
#──────────────────────────────────────────────────────
  .global sprint_hex
sprint_hex:
    STACK16


    #-- Guardar los parametros
    sw a0, 0(sp)  #-- Buffer
    sw a2, 4(sp)  #-- Tamaño del numero
    sw a3, 8(sp)  #-- Espacios iniciales

    #-- Convertir a array bcd
    #-- Guardarlo en un buffer interno
    la a0, __buff
    jal bcd_to_bcd_array

    #-- Convertir a cadena
    la a0, __buff
    lw a1, 4(sp)    #-- Tamaño en bits
    srli a1, a1, 2  #-- Tamaño en digitos
    jal bcd_array_to_string

    #-- Comprobar si hay que eliminar ceros iniciales o no
    lw a3, 8(sp)
    beq a3, zero, 1f

    #-- Hay que eliminar los 0s
    la a0, __buff
    jal str_remove_leading_zeros

    #-- a0: cadena sin ceros
    j 2f
    
# no_remove_ceros:
1:
    #-- Seleccionar cadena desde el principio
    la a0, __buff

2:

    #-- Copiar el numero-cadena en el buffer de la cadena
    #-- La cadena origen a0 contiene bien el numero completo
    #-- o bien apunta al numero sin 0s iniciales
    lw a1, 0(sp)  #-- buffer destino
    jal strcpy

    UNSTACK16


#──────────────────────────────────────────────────────
#──  Imprimir un numero en decimal
#──
#──  ENTRADAS:
#──    a0: Buffer donde imprimir
#──    a1: Numero a imprimir
#──    a2: Tamaño del numero (4,8,16,32)
#──    a3: Eliminar 0s iniciales (0=No, 1=si)
#── 
#──  SALIDAS:
#──    a0: Direccion donde comienza la cadena
#──────────────────────────────────────────────────────
  .global sprint_uint
sprint_uint:
    STACK16

    #-- Guardar los parametros
    sw a0, 0(sp)  #-- Buffer
    sw a2, 4(sp)  #-- Tamaño del numero
    sw a3, 8(sp)  #-- Espacios iniciales

    #-- Convertir numero decimal a digitos bcd
    mv a0, a1
    jal uint32_to_bcd
    
    #-- DEBUG
    # li t0, 0x00200000
    # sw a0, 0(t0)
    # j .

    #-- a1 y a0 tienen los digitos bcd
    mv t0, a0
    mv t1, a1

    #-- Convertir a array de digitos bcd
    la a0, __buff
    mv a1, t0
    #-- TODO: Falta convertir a1 para numeros grandes
    jal bcd_to_bcd_array

    #-- Convertir a cadena
    la a0, __buff
    lw a1, 4(sp)    #-- Tamaño en bits
    jal bcd_array_to_string

    #-- Comprobar si hay que eliminar ceros iniciales o no
    lw a3, 8(sp)
    beq a3, zero, 1f

    #-- Hay que eliminar los 0s
    la a0, __buff
    jal str_remove_leading_zeros

    #-- a0: cadena sin ceros
    j 2f
    
# no_remove_ceros:
1:
    #-- Seleccionar cadena desde el principio
    la a0, __buff

2:

    #-- Copiar el numero-cadena en el buffer de la cadena
    #-- La cadena origen a0 contiene bien el numero completo
    #-- o bien apunta al numero sin 0s iniciales
    lw a1, 0(sp)  #-- buffer destino
    jal strcpy

    UNSTACK16







#──────────────────────────────────────────────────────
#──  Imprimir un numero en binario
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


#──────────────────────────────────────────────────────
#──  Imprimir un numero en hexadecimal
#──
#──  ENTRADAS:
#──    a0: Numero a imprimir en hexadecimal
#──    a1: Tamaño del numero (4, 8, 16, 32)
#──    a2: Eliminar 0s iniciales (0=No, 1=si)
#── 
#──────────────────────────────────────────────────────
  .global print_hex
print_hex:

    STACK16

    #-- La impresion se hace en 2 fase:
    #-- Fase 1: Imprimir el numero en un buffer interno
    mv a3, a2
    mv a2, a1
    mv a1, a0
    la a0, __sprint_buffer
    jal sprint_hex

    #-- Fase 2: Imprimir el buffer en la consola
    la a0, __sprint_buffer
    jal puts

    UNSTACK16

#──────────────────────────────────────────────────────
#──  Imprimir un numero en decimal
#──
#──  ENTRADAS:
#──    a0: Numero a imprimir en decimal
#──    a1: Tamaño del numero en bits (4, 8, 16, 32)
#──    a2: Eliminar 0s iniciales (0=No, 1=si)
#── 
#──────────────────────────────────────────────────────
  .global print_uint
print_uint:

    STACK16

    #-- La impresion se hace en 2 fase:
    #-- Fase 1: Imprimir el numero en un buffer interno
    mv a3, a2
    mv a2, a1
    mv a1, a0
    la a0, __sprint_buffer
    jal sprint_uint

    #-- Fase 2: Imprimir el buffer en la consola
    la a0, __sprint_buffer
    jal puts

    UNSTACK16



    .section   .sdata

#-- Buffer para instrucciones sprint
__sprint_buffer: .space 255

#-- Buffer interno para la impresion de numeros
__buff: .space 33
