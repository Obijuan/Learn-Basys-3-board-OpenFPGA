#──────────────────────────────────────────────────────
#──    BIBLIOTECA PARA LA UART
#──  Funciones de bajo nivel
#──────────────────────────────────────────────────────
    .include "stack.h"
    .include "peripherals.h"


#--------------------------------------------------------------
#-- uart_wait_tx_ready()
#--
#-- Esperar hasta que el bit TX_EMPTY del transmisor
#-- se ponga a 1
#--
#-- El registro tp debe contener la direccion base de la uart
#--------------------------------------------------------------
    .global uart_wait_tx_ready
uart_wait_tx_ready:
    #-- Leer el registro de status de la UART
    lb t0, UART_TX_STATUS(tp)
    
    #-- Aislar el bit TX_EMPTY
    andi t0, t0, UART_TX_STATUS_EMPTY
    
    #-- Si el bit es 0, el transmisor no esta listo
    #-- repetimos la accion hasta que se ponga a 1
    beq t0, zero, uart_wait_tx_ready

    #-- Retornar al caller
    ret


#---------------------------------------------------------------
#-- putchar(c): Imprimir un caracter
#--
#-- ENTRADA:
#--   - a0 (c): Carácter a imprimir
#--
#-- El registro tp debe contener la direccion base de la uart
#---------------------------------------------------------------
    .global putchar
putchar:

	STACK16
	
    #-- Guardar a0 en la pila
    sw a0, 0(sp)

	#-- Esperar a que el transmisor esté listo
	jal uart_wait_tx_ready
	
	#-- Escribir el caracter en el registro de datos
    lw a0, 0(sp) #-- Sacarlo de la pila
	sb a0, 0(tp) #-- Transmitir!
	
	#-- Recuperar la dirección de retorno y liberar la pila
	UNSTACK16

