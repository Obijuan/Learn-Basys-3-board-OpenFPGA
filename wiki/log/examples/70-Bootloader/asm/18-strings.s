    .include "so.h"
    .include "peripherals.h"
    .include "ansi.h"
    .include "uart.h"
    .include "stack.h"

    .text

       .global __reset
__reset:

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Poner patron inicial en los leds
    li t0, 0xF00F
    sw t0, 0(s0)

    #--- Borrar pantalla
    ANSI_HOME
    ANSI_CLS

    

    la a0, buff
    li a1, 0x0000000F
    #li a1, 0xFFFFFFFF
    li a2, 1   #-- sin 0s iniciales
    li a2, 0   #-- con 0s iniciales

    #-- Almacenar parametros a0 y a2 para no perderlos
    mv s0, a0 #sw a0, 0(sp) #-- Buffer
    mv s1, a2 #sw a2, 4(sp) #-- Eliminar digitos

    #-- Convertir numero decimal a digitos bcd
    mv a0, a1
    jal uint32_to_bcd

    #-- a1 a0: Digitos bcd. a1: 2: a0: 8
    #-- Almacenar a0
    mv s2, a0

    #-- Convertir la parte alta (a1) a bcd-array
    li a2, 8     #-- Tamaño en bits
    #-- a1 contiene el bcd
    mv a0, s0 #la a0, buff
    jal bcd_to_bcd_array

    #-- Convertir la parta baja a bcd-array
    li a2, 32    #-- Tamaño en bits
    mv a1, s2
    #-- a0: final del array
    jal bcd_to_bcd_array

    #-- Convertir a cadena
    mv a0, s0 #la a0, buff
    li a1, 10  #-- Tamaño en digitos (2 parte alta, 8 baja)
    jal bcd_array_to_string

    #-- Comprobar si hay que eliminar ceros iniciales o no
    beq s1, zero, 1f

    #-- Hay que eliminar los 0s
    mv a0, s0 #la a0, __buff
    jal str_remove_leading_zeros

    #-- a0: cadena sin ceros
    j 2f

# no_remove_ceros:
1:
    #-- Seleccionar cadena desde el principio
    mv a0, s0 #la a0, __buff

2:

    #-- Copiar el numero-cadena en el buffer de la cadena
    #-- La cadena origen a0 contiene bien el numero completo
    #-- o bien apunta al numero sin 0s iniciales
    la a1, buff1 #lw a1, 0(sp)  #-- buffer destino
    jal strcpy


    #-- Imprimir la cadena
    la a0, buff1
    jal puts

    PUTCHARI '\n'
    PUTSI "holi holi holi holi....\n"

    #-- DEBUG
    #li s0, 0x00200000
    #sw a0, 0(s0)
    #j .

    la a0, buff1
    li a1, 13
    #li a1, 0xFFFFFFFF
    li a2, 1   #-- sin 0s iniciales
    li a2, 0   #-- con 0s iniciales
    jal sprint_uint

    la a0, buff1
    jal puts
    PUTCHARI '\n'
    PUTSI "---FIN\n"



    #---- Imprimir numeros de 4 bits
    # PUTSI "--> Numeros de 4 bits\n"
    # PUTSI "* Bin4: "
    # PRINT_BIN4I 0xC
    # PUTCHARI '\n'

    # PUTSI "* Hex4: "
    # PRINT_HEX4I 0xC
    # PUTCHARI '\n'

    # PUTSI "* Dec4: "
    # PRINT_UINT4I 0xC
    # PUTCHARI '\n'

    # PUTSI "* Dec4 (max): "
    # PRINT_UINT4I 0xF
    # PUTCHARI '\n'

    # PUTCHARI '\n'

    # #---- Imprimir numeros de 8 bits
    # PUTSI "--> Numeros de 8 bits\n"
    # PUTSI "* Bin8: "
    # PRINT_BIN8I 0x55
    # PUTCHARI '\n'

    # PUTSI "* Hex8: "
    # PRINT_HEX8I 0x55
    # PUTCHARI '\n'

    # PUTSI "* Dec8: "
    # PRINT_UINT8I 0x55
    # PUTCHARI '\n'

    # PUTSI "* Dec8 (max): "
    # PRINT_UINT8I 0xFF
    # PUTCHARI '\n'

    # PUTCHARI '\n'

    # #----- Imprimir numeros de 16 bits
    # PUTSI "--> Numeros de 16 bits\n"
    # PUTSI "* Bin16: "
    # PRINT_BIN16I 0xAAAA
    # PUTCHARI '\n'

    # PUTSI "* Hex16: "
    # PRINT_HEX16I 0xAAAA
    # PUTCHARI '\n'

    # PUTSI "* Dec16: "
    # PRINT_UINT8I 0xAAAA
    # PUTCHARI '\n'

    # PUTSI "* Dec16 (max): "
    # PRINT_UINT8I 0xFFFF
    # PUTCHARI '\n'

    # PUTCHARI '\n'

    # #----- Imprimir numeros de 32 bits
    # PUTSI "--> Numeros de 32 bits\n"
    # PUTSI "* Bin32: "
    # PRINT_BIN32I 0xCAFEBACA
    # PUTCHARI '\n'

    # PUTSI "* Hex32: "
    # PRINT_HEX32I 0xCAFEBACA
    # PUTCHARI '\n'

    # #----- TODO: NO FUNCIONA!!! DEBUG!!!!!!!!!
    # PUTSI "* Dec32: "
    # PRINT_UINT32I 0xCAFEBACA
    # PUTCHARI '\n'

    halt


    .data
buff:   .space 255
buff1:   .space 255
src:    .string "0000123456789\n"    
dst:    .string "****************\n"
