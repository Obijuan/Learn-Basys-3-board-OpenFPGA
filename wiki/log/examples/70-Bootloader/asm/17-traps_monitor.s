#──────────────────────────────────────────────────────
#──  Probando las traps...
#──────────────────────────────────────────────────────
    .include "so.h"
    .include "peripherals.h"
    .include "delay.h"
    .include "ansi.h"

    #-- Configuracion secuencia en los LEDs
    .equ VALOR1, 0xAAAA
    .equ VALOR2, 0x5555
    .equ PAUSA, _100ms


    .text

    .global __reset
__reset:

    #-- Inicializar la pila
    la sp, __ram_end

    #-- s0: Acceso a los LEDs
    li s0, LEDS_ADDR

    #-- Mostrar patron inicial en los leds
    li t0, 0x8001
    sw t0, 0(s0)

    #--- Configuracion de la rutina de atencion
	#--- a la interrupcion
	la t0, servicio
	csrw mtvec, t0

    ANSI_RESET
    ANSI_HOME
    ANSI_CLS
    PUTSI "------------------------------\n"
    PUTSI "  Main: Probando excepciones  \n"
    PUTSI "------------------------------\n"
    PUTSI "0. Fetch misaligned\n"
    PUTSI "1. Fetch fault\n"
    PUTSI "2. Ilegal instruction\n"
    PUTSI "3. ebreak\n"
    PUTSI "4. Load misaligned\n"
    PUTSI "5. Load fault\n"
    PUTSI "6. Store misaligned\n"
    PUTSI "7. Store fault\n"
    PUTSI "b. ecall\n"
    PUTSI "Opcion: "

    #-- Leer opciones
 ask_user:
    jal getchar

    li t0, '0'
    beq a0, t0, generar_fetch_misalined

    li t0, '1'
    beq a0, t0, generar_fetch_fault

    li t0, '2'
    beq a0, t0, generar_ilegal_instruction

    li t0, '3'
    beq a0, t0, generar_ebreak

    li t0, '4'
    beq a0, t0, generar_load_misaligned

    li t0, '5'
    beq a0, t0, generar_load_fault

    li t0, '6'
    beq a0, t0, generar_store_misaligned

    li t0, '7'
    beq a0, t0, generar_store_fault

    li t0, 'b'
    beq a0, t0, generar_ecall

    #-- Opcion no conocida: Ignorar
    j ask_user

 #---------------------------------------------------
 #-- Generar la excepcion FETCH_MISALINEG. Codigo 0
 #---------------------------------------------------
 generar_fetch_misalined:
    la t0, test_fetch_misaligned
    addi t0, t0, 2
    jalr zero, 0(t0)

  test_fetch_misaligned:
    halt

 #--------------------------------------------------
 #-- Generar la excepcion FETCH_FAULT. Codigo 1
 #--------------------------------------------------
 generar_fetch_fault:
    mv t0, zero
    jalr t0
 
 #------------------------------------------------------
 #-- Generar la excepcion ILEGAL_INSTRUCTION. Codigo 2
 #------------------------------------------------------
 generar_ilegal_instruction:
    .word 0

 #---------------------------------------------------
 #-- Generar la excepcion LOAD_MISALIGNED. Codigo 4
 #---------------------------------------------------
 generar_load_misaligned:
   la t0, load_misaligned
   addi t0,t0,1
   lw zero, 0(t0)

   load_misaligned:
     nop

 #-------------------------------------------------------
 #-- Generar la excepcion LOAD FAULT. Codigo 5
 #-------------------------------------------------------			
 generar_load_fault:
    lw zero, (zero)

 #-------------------------------------------------------
 #-- Generar la excepcion STORE MISALIGNED. Codigo 6
 #-------------------------------------------------------
 generar_store_misaligned:
    la t0, store_misaligned
    addi t0,t0,1
    sw zero, 0(t0)

    store_misaligned:
        nop

 #-----------------------------------------------
 #-- Generar excepcion STORE FAULT. Codigo 7
 #-----------------------------------------------
 generar_store_fault:
    sw zero, (zero)

 #-----------------------------
 #-- Generar llamada EBREAK
 #-----------------------------
 generar_ebreak:
    ebreak

 #-----------------------------
 #-- Generar llamada ECALL
 #-----------------------------
 generar_ecall:
    ecall


#------------------------------------------
#-- Rutina de atencion a la interrupcion
#------------------------------------------
servicio:

    ANSI_RED
    PUTSI "\n\n--> TRAP!\n"
    ANSI_RESET

    #-- Determinar la causa de la trap
    #-- 1o: Leer la causa de la trap
    csrr t0, mcause

    #-- Si bit 31 es 1, es una interrupcion. 
    #-- Si bit 31 es 0, es una excepcion
    blt t0, zero, servicio_interrupt

    #-- Es una excepcion!!!
    j servicio_excepcion


#-------------------------------------------------
#-- Atencion a las excepciones!!!
#-------------------------------------------------
servicio_excepcion:

    PUTSI "* Es una excepcion\n"

    #-- Leer causa de interrupcion y mostrarla en el display
    csrr a0, mcause
    jal disp_hex4

    #-- Escribir un texto diciendo que tipo de excepcion es
    ANSI_BLUE

    csrr a0, mcause
    andi a0, a0, 0xff
    li t0, 0
    beq a0, t0, msg_fetch_misaligned

    li t0, 1
    beq a0, t0, msg_fetch_fault

    li t0, 2
    beq a0, t0, msg_ilegal_instruction

    li t0, 3
    beq a0, t0, msg_ebreak

    li t0, 4
    beq a0, t0, msg_load_misaligned

    li t0, 5
    beq a0, t0, msg_load_fault

    li t0, 6
    beq a0, t0, msg_store_misaligned

    li t0, 7
    beq a0, t0, msg_store_fault

    li t0, 11
    beq a0, t0, msg_ecall
    
    ANSI_RED
    PUTSI "Exepcion desconocida!\n"
    j animation

 msg_fetch_misaligned:
    PUTSI "--> FETCH MISALIGNED. Codigo 0\n"
    j animation

 msg_fetch_fault:
    PUTSI "--> FETCH FAULTS. Codigo 1\n"
    j animation

 msg_ilegal_instruction:
    PUTSI "--> ILEGAL INSTRUCTION. Codigo 2\n"
    j animation

 msg_load_misaligned:
    PUTSI "--> LOAD MISALIGNED. Codigo 4\n"
    j animation

 msg_load_fault:
    PUTSI "--> LOAD FAULT. Codigo 5\n"
    j animation

 msg_ebreak:
    PUTSI "--> EBREAK. Codigo 3\n"
    j animation

 msg_store_misaligned:
    PUTSI "--> STORE MISALIGNED. Codigo 6\n"
    j animation

 msg_store_fault:
    PUTSI "--> STORE FAULS. Codigo 7\n"
    j animation

 msg_ecall:
    PUTSI "--> ECALL. Codigo 11\n"
    j animation
 

 animation:
    #-- Establecer valor 1 de la secuencia
    li t0, VALOR1
    sw t0, 0(s0)

    #-- Pausa
    li a0, PAUSA
    jal delay

    #-- Establecer valor 2 de la secuencia
    li t0, VALOR2
    sw t0, 0(s0)

    #-- Pausa
    li a0, PAUSA
    jal delay

    jal read_buttons
    andi a0, a0, 0x1F
    beq a0, zero, animation

    #-- boton apretado
    #-- Saltar al comienzo del programa
    la t0, __reset

    #-- Guardar valor en mepc
    csrw mepc, t0

    #-- Retornar
    mret

 #-------------------------------------
 #-- Atencion a las interrupciones
 #-- Solo hay 2 interrupciones:
 #--    - Debido al timer
 #--    - Debido a la UART
 #------------------------------------
 servicio_interrupt:

    PUTSI "Es una interrupcion"

    #--- Mostrar secuencia especifica en los leds
    li t0, 0x7
    sw t0, 0(s0)

    halt


