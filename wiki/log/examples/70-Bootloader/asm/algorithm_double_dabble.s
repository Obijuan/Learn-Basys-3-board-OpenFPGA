    .include "stack.h"

#--------------- algorithm_dd_init ---------------------------

 #-------------------------------------------------------------
 #-- uint_buffer_init(n): 
 #--
 #--  Inicializar el buffer del algoritmo Doubble Dabble
 #--  
 #--     Alta    Media    Baja
 #--  |   0    |    0   |  n  |
 #--
 #-- ENTRADA:
 #--   - a0 (n): Numero a imprimir
 #-------------------------------------------------------------

	.section .sdata

	#-- Buffer para implementar el algoritmo Doubble Dabble
 uint_buffer: 
	.word 0 #-- Parte baja del buffer (Contiene el numero inicial)
	.word 0 #-- Parte media (Contiene los digitos BCD 7-0)
	.word 0 #-- Parte alta (Contiene los digitos BCD 9-8)

    .text

    .global algorithm_dd_init
algorithm_dd_init:

    #-- Inicializar los buffers
	la t0, uint_buffer

	sw a0, 0(t0) #-- Parte baja
	sw zero, 4(t0) #-- Parte media
	sw zero, 8(t0) #-- Parte alta

	ret


#----------------------------------------------------------------
#-- Devolver el resultado del algoritmo, almacenado en el buffer
#--
#-- SALIDAS:
#--   a1: (bcd32): Digitos bcd de mayor peso
#--   a0: (bcd32): Digitos bcd de menor peso
#----------------------------------------------------------------
    .global algorithm_dd_read_buffer
algorithm_dd_read_buffer:

    la t0, uint_buffer
    lw a1, 8(t0)  #-- Parte alta
    lw a0, 4(t0)  #-- Parte baja

    ret


#--------------- algorithm_dd_shift1 ---------------------------
algorithm_dd_shift1:
 #-------------------------------------------------------------
 #-- uint_buffer_shift1_left(shift)
 #--   Desplazar el uint_buffer 1 bit a la izquierda
 #--
 #-------------------------------------------------------------
 	.global algorithm_dd_shift1

	#-- Obtener el uint_buffer
	#-- t2, t1, t0: Parte alta, media y baja
	la t3, uint_buffer
	lw t0, 0(t3)
	lw t1, 4(t3)
	lw t2, 8(t3)

	#-------- t2 <-- t1 <-- t0

	#-- t2 << 1
    slli t2, t2, 1

	#-- Leer el bits de mayor peso de t1
	lui a0, 0x80000
	and a1, t1, a0

	#-- Moverlos a la parte baja
	srli a1, a1, 31

	#-- Poner esos bits en t2
	or t2, t2, a1

	#-- t1 << 1
	slli t1, t1, 1

	#-- Leer 3 bits de mayor peso de t0
	and a0, t0, a0

	#-- Moverlos a la parte baja
	srli a0, a0, 31

	#-- Poner esos bits en t1
	or t1, t1, a0

	#-- t0 << 1
	slli t0, t0, 1

	#-- Actualizar el uint_buffer
	sw t0, 0(t3)
	sw t1, 4(t3)
	sw t2, 8(t3)

	ret


#----------------- uint_buffer_update_all() ------------
algorithm_dd_step:
 #-----------------------------------------------------------------
 #-- uint_buffer_update()
 #--
 #--   Actualizar todos los digitos BCD del registro uint_buffer
 #-----------------------------------------------------------------
	.global algorithm_dd_step

	STACK16

	#-- Actualizar los digitos BCD de la parte media 
	li a0, 4
	jal algorithm_dd_update

	#-- Actualizar los digitos BCD de la parte alta
	li a0, 8
	jal algorithm_dd_update
	
	UNSTACK16
#----------------------------------------------


#----------------- uint_buffer_update(offset)
algorithm_dd_update:
 #--------------------------------------------------------------------------
 #-- uint_buffe_update(offset)
 #-- 
 #--   Actualizar la parte alta o baja del registro uint_buffer
 #--   Los digitos BCD de la parte indicada se actualizan
 #--   segun indica el algoritmo Doubble Dabble
 #-- 
 #--  ENTRADA:
 #--    - a0 (offset): Offset para acceder a la parte alta (8) ó media (4)
 #--------------------------------------------------------------------------
	.global algorithm_dd

	STACK16
	PUSH3 s0,s1,s2

	#-- Obtener la direccion base del registro uint_buffer
	la s0, uint_buffer

	#-- Aplicar el offset
	add s0, s0, a0

	#-- s0: Apunta a la parte del registro uint_buffer a actualizar
	#-- s1: valor actual de la parte del registro uint_buffer
	lw s1, 0(s0)

	#-- s2: Contiene el numero de digito actual
	li s2, 8  #-- s7 = ndig

	#-- Aplicar a los 8 digitos bcd
 uint_buffer_update_loop:

	#-- Decrementar el numero de digito
	addi s2, s2, -1

	#-- Obtener digito bcd actual
	mv a0, s1  #-- value
	mv a1, s2  #-- ndig
	li a2, 4   #-- dig_size
	jal BCD_get_digit

	#-- a0 = digito BCD
	#-- Si a0 > 4, a0 = a0 + 3
	li t0, 4
	ble a0, t0, uint_buffer_update_cont

	#-- Sumar 3
	addi a0, a0, 3

 uint_buffer_update_cont:

	#-- Actualizar el digito bcd
	mv a2, a0  #-- bcd
	mv a0, s1  #-- value
	mv a1, s2  #-- ndig
	jal BCD_set_digit

	#-- a0: Valor actualizado del registro uint_buffer
	mv s1, a0

	#-- Es ndig==0? si ndig > 0, repetir bucle
	bgt s2, zero, uint_buffer_update_loop

	#---- FIN DEL BUCLE
	#---- Todos los digitos BCD actualizados

	#-- Actualizar el registro uint_buffer en memoria
	sw s1, 0(s0)

	POP3 s0,s1,s2
	UNSTACK16



#------------ BCD_get_digit(value, ndig, dig_size) ------------
BCD_get_digit:
	#------------------------------------------------------------------------
	#-- BCD_get_digit(value, ndig, dig_size)
	#--
	#--  Obtener el digito BCD numero ndig dentro del valor value, cuyo 
	#--  tamaño en bits se indica con size
	#--
	#-- ENTRADAS:
	#--   -a0 (value): Valor del que se quieren extraer el digito (32-bits)
	#--   -a1 (ndig): Numero del digito a extraer (0-31)
	#--   -a2 (dig_size): Tamaño/tipo de digito:
	#--      1 : Se trata de un bit
	#--      2 : Se trata de un digito cuaternario (0-3)
	#--      3 : Se trata de un digito octal (0-7)
	#--      4 : Se trata de un digito decimal o hexadecimal (0-9, A-F)
	#-----------------------------------------------------------------------
	.global BCD_get_digit

	STACK32

	#-- Guardar los registros estaticos usados
	STACK32_PUSH4 s0, s1, s2, s3

	#-- Guardar los parametros
	mv s0, a0 #-- value
	mv s1, a1 #-- ndig
	mv s2, a2 #-- size

	#-- Paso 1: generar la máscara para extraer el digito
	#-- s4: Mascara
	mv a0, a2
	jal BCD_get_mask
	mv s3, a0

	#-- Paso 2: Obtener la posicion del digito
	#-- t0: Posicion del digito
	mv a0, s1
	mv a1, s2
	jal BCD_get_digit_pos
	mv t0, a0

	#-- Paso 3: Desplazar la mascara a la izquierda
	sll s3, s3, t0

	#-- Paso 4: Aplicar la mascara al valor original
	mv a0, s0
	and a0, a0, s3

	#-- Paso 5: Desplazar el resultado a la derecha para obtener el digito
	srl a0, a0, t0

	STACK32_POP4 s0, s1, s2, s3  #-- Recuperar los registros estaticos
	UNSTACK32
	ret


#----------------- BCD_set_digit(value, ndig, bcd)
BCD_set_digit:
 #-----------------------------------------------------------------------
 #-- BCD_set_digit(value, ndig, bcd)  
 #--
 #-- Insertar el digito bcd (de 4 bits) en la posicion ndig de value
 #--
 #-- ENTRADAS:
 #--   -a0 (value): Valor inicial
 #--   -a1: (ndig) Numero de digito BCD donde insertar el nuevo valor (7-0)
 #--   -a2: (bcd) Valor bcd (4 bits)
 #--
 #-- SALIDA:
 #--   -a0: Nuevo valor actualizado
 #----------------------------------------------------------------------
 #-- Pruebas:
 #--   BCD_set_digit(0x0, 0, 0xA) --> 0x0000_000A
 #--   BCD_set_digit(0xFFFFFFFF, 0, 0xA) --> 0xFFFFFFFA
 #--   BCD_set_digit(0x00000000, 1, 0x5) --> 0x00000050
 #--   BCD_set_digit(0xCAFEBACA, 1, 0x5) --> 0xCAFEBA5A
 #--   BCD_set_digit(0x00000000, 2, 0xF) --> 0x00000F00
 #--   BCD_set_digit(0xDEADBEEF, 2, 0x0) --> 0xDEADB0EF
 #--   BCD_set_digit(0x00000000, 7, 0xC) --> 0xC0000000
 #--   BCD_set_digit(0xCAFEBACA, 7, 0xB) --> 0xBAFEBACA 
	.global BCD_set_digit

	#-- 1. t0: Mascara de 4 bits para acceder a campo BCD
	li t0, 0xF

	#-- 2. t1: Posicion del campo a actualizar
	#--    pos = ndig * 4  (pos = ndig << 2)
	slli t1, a1, 2

	#-- 3. t0: Mascara posicionada sobre el campo BCD a modificar
	#--   mask << pos
	sll t0, t0, t1

	#-- 4. t0: Máscara negada (para borrar campo BCD actual)
	xori t0, t0, -1  #-- t0 = not t0

	#-- 5. Borrar campo bcd: value = value and t0
	and a0, a0, t0

	#-- 6. Llevar el nuevo valor (bdd) a su posicion
	#--  bcd = bcd << pos
	sll a2, a2, t1

	#-- 7. Añadir el valor bcd: value = value | bcd
	or a0, a0, a2

	#-- Devolver el valor actualizado 
	ret



#------------ BCD_get_mask(size) ------------------------------------
BCD_get_mask:
	#---------------------------------------------
	#-- BCD_get_mask(size)
	#--
	#--   Obtener una mascara de size bits
	#--
	#-- BCD_get_mask(1) = 0x0000_0001
	#-- BCD_get_mask(2) = 0x0000_0011
	#-- BCD_get_mask(3) = 0x0000_0111
	#-- BCD_get_mask(4) = 0x0000_1111
	#--
	#--- ENTRADAS:
	#--   -a0 (size): Tamaño en bits
	#--     -1: Digito binario
	#--     -2: Digito cuaternario
	#--     -3: Digito octal
	#--     -4: Digito decimal/hexa
	#--
	#--  SALIDA:
	#--   - (a0) Mascara
	#---------------------------------------------
	.global BCD_get_mask			
	

	#-- Limitar el tamaño: Si es menor a 5, OK
	#-- En caso contrario recortar a 4
	li t0, 5
	blt a0, t0, BCD_get_mask_ok
	
	#-- Es mayor a 4, recortar
	li a0, 4
	
  BCD_get_mask_ok:

	#-- Valor inicial de la mascara
	li t0, -1  #-- t0 = 0xFFFF_FFFF
	
	#-- Desplazar tantos bits a la izquierda como indique size
	sll t0, t0, a0
	
	#-- Negar los bits para obtener la mascara final
	xori a0, t0, -1

	ret				    


    #------------ BCD_get_digit_pos(ndig, size) -------------------
BCD_get_digit_pos:
	#-------------------------------------------------------------
	#-- BCD_get_digit_pos(ndig, size)
	#--
	#--  Obtener la posicion del digito BCD de tamaño size
	#--
	#-- ENTRADAS:
	#--   -a0 (ndig): Numero del digito a extraer (0-31)
	#--   -a1 (size): Tamaño/tipo de digito:
	#-- SALIDA:
	#--   -a0 (pos) Posicion del digito dentro (0-31)
	#--------------------------------------------------------------
	.global BCD_get_digit_pos

	#-- La implementacion rapida es multiplicar ndig por size
	#-- return ndig * size

	#-- Pero lo implementamos con sumas porque no disponemos
	#-- de la multiplicacion
	#-- pos = ndig + ndig + ... (size veces)

	#-- resultado parcial
	li t0, 0

	#-- Repetir size veces
  BCD_get_digit_pos_loop:

	#-- ¿Tamaño 0?
	beq a1, zero, BCD_get_digit_pos_end

	#-- Realizar la suma parcial
	add t0, t0, a0

	#-- Decrementar el tamaño
	addi a1, a1, -1

	#-- Repetir
	j BCD_get_digit_pos_loop

  BCD_get_digit_pos_end:
    #-- Devolver la posicion
	mv a0, t0
	ret

