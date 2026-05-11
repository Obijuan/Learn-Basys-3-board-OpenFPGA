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

    #-- Leer la direccion base de la UART
    li t1, UART_ADDR

    #-- Leer el registro de status de la UART
    lb t0, UART_TX_STATUS(t1)
    
    #-- Aislar el bit TX_EMPTY
    andi t0, t0, UART_TX_STATUS_EMPTY
    
    #-- Si el bit es 0, el transmisor no esta listo
    #-- repetimos la accion hasta que se ponga a 1
    beq t0, zero, uart_wait_tx_ready

    #-- Retornar al caller
    ret

#--------------------------------------------------------------
#-- uart_wait_rx_ready()
#--
#-- Esperar hasta que el bit RX_FULL del receptor
#-- se ponga a 1
#--
#-- El registro tp debe contener la direccion base de la uart
#--------------------------------------------------------------
uart_wait_rx_ready:

    #-- Leer la direccion base de la UART
    li t1, UART_ADDR

wait_rx:
	#-- Leer el registro de estado del receptor
	lb t0, UART_RX_STATUS(t1)
	
	#-- Aislar el bit RX_FULL
	andi t0, t0, UART_RX_STATUS_FULL
	
	#-- Si el bit es 0, no se ha recibido ningun caracter
	#-- (el receptor NO está listo)
	#-- repetimos la accion hasta que se ponga a 1
	beq t0, zero, wait_rx
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
	
    #-- Leer la direccion base de la UART
    li t1, UART_ADDR

	#-- Escribir el caracter en el registro de datos
    lw a0, 0(sp) #-- Sacarlo de la pila
	sb a0, 0(t1) #-- Transmitir!
	
	#-- Recuperar la dirección de retorno y liberar la pila
	UNSTACK16

#--------------------------------------------------------
#-- getchar()
#--
#-- Esperar a que se pulse una tecla
#-- Esta funcion es BLOQUEANTE
#--
#-- SALIDA:
#--   a0 (car): Caracter introducido por el usuario
#--
#-- Se supone que el registro tp contiene la direccion
#--   base de la UART
#-------------------------------------------------------
.global getchar
getchar:
    STACK16

    #-- Esperar a que se recibe un caracter
    jal uart_wait_rx_ready
    
    #-- Leer la direccion base de la UART
    li t1, UART_ADDR

    #-- Leer el caracter recibido
    lb a0, UART_DATA(t1)

    UNSTACK16

