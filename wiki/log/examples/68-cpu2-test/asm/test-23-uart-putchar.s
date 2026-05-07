.include "so.h"
.include "stack.h"
.include "delay.h"

#-- Direccion de los LEDs
.equ LEDS, 0x200000

#-- Direccion de la UART
.equ UART, 0x210000

#<--------- TX STATUS ---------> <-------- RX STATUS ---------> 
#|           31...24           |||          23...16           ||
#| 31-27|   26   |  25 |  24   ||| 23-19|   18  |  17 |  16   ||
#| xxxxx|TX_EMPTY|TX_IE|TX_ERR ||| xxxxx|RX_FULL|RX_IE|RX_ERR ||

#<----------> <- BUFFER ->
#|  15...8  |||  7...0   |
#| 15-----8 ||| 7------0 |
#| xxxxxxxx |||  BUFFER  |

#-- Máscaras de acceso a los bits
#-- Bit Ready del transmisor
.equ TX_EMPTY, 0x04000000  

#-- Pausa a realizar en secuencia leds
.equ PAUSA, _50ms

.global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- gp -> Direccion de los leds
    li gp, LEDS

    #-- tp -> Direccion de la UART
    li tp, UART


    #----- Enviar caracteres individuales
	li a0, 'H'
	jal putchar
	
	li a0, 'O'
	jal putchar
	
	li a0, 'L'
	jal putchar
	
	li a0, 'A'
	jal putchar

#------------------------------------
#-- TESTs pasado con exito
#------------------------------------

    #-- Mostrar una secuencia
1:
    li a0, 0x01  #-- Valor inicial seq
    li a1, 0x01  #-- Bits a desplazar a la izq
    li a2, 16    #-- Numero de pasos
    jal play1
    j 1b


#----- Dependencias
.include "io-uart.s"
.include "delay.s"
.include "seq.s"

