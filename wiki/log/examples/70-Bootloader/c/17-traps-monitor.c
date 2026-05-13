//──────────────────────────────────────────────────────
//──  Probando las traps...
//──────────────────────────────────────────────────────
#include "peripherals.h"
#include "so.h"
#include "ansi.h"
#include "uart.h"
#include "disp7.h"
#include "delay.h"
#include "buttons.h"

//-- Rutina de atencion a la interrupcion
void servicio();
void servicio_int();
void servicio_excepcion(uint32_t); 

//-- Configuracion secuencia en los LEDs
#define VALOR1 0xAAAA
#define VALOR2 0x5555
#define PAUSA _100ms


void menu() 
{
    //-- Borrar la pantalla
    _puts(ANSI_RESET);
    _puts(ANSI_HOME);
    _puts(ANSI_CLS);

    _puts("------------------------------\n");
    _puts("  Main: Probando excepciones  \n");
    _puts("------------------------------\n");
    _puts("EXCEPCIONES:\n");
    _puts(" 0. Fetch misaligned\n");
    _puts(" 1. Fetch fault\n");
    _puts(" 2. Ilegal instruction\n");
    _puts(" 3. ebreak\n");
    _puts(" 4. Load misaligned\n");
    _puts(" 5. Load fault\n");
    _puts(" 6. Store misaligned\n");
    _puts(" 7. Store fault\n");
    _puts(" b. ecall\n");
    _puts("\nINTERRUPCIONES: \n");
    _puts(" c. Timer\n");
    _puts(" d. UART RX\n");
    _puts(" e. UART TX\n");
    _puts("Opcion: ");
}


void main()
{
    //-- Mostrar patron inicial en los leds
    LEDS = 0x8001;

    //-- Deshabilitar las interrupciones
    asm volatile("csrw mie, zero");
    asm volatile("csrw mstatus, %0": : "r"(MSTATUS_MIE_MASK));

    //--- Configuracion de la rutina de atencion
	//--- a la interrupcion
    asm("csrw mtvec, %0": : "r"(servicio));

    //-- Sacar el menu
    menu();

    //-- Bucle principal
    for (;;) {

        //-- Esperar peticion del usuario
        char c = _getchar();
        LEDS = c;

        switch(c) {

            //--------------------------------------
            //---- FETCH MISALIGNED
            //---- Codigo 0
            //--------------------------------------
            case '0': 
                asm volatile (
                    "   la t0, 1f         \n\t"
                    "   addi t0,t0,2      \n\t"
                    "   jalr zero, 0(t0)  \n\t"
                    "1:                   \n\t"
                    :                     // Sin salidas
                    :                     // Sin entradas
                    : "t0"                // usamos t0
                );
                break;
        }

        //-- Ninguna opcion valida
        //-- Volver a pedir
    }

}


__attribute__((interrupt))
void servicio() {

    //-- Registro mstatus
    uint32_t mcause;

    _puts(ANSI_RED);
    _puts("\n\n--> TRAP!\n");
    _puts(ANSI_RESET);

    //-- Determinar la causa de la trap
    //-- 1o: Leer la causa de la trap
    asm volatile("csrr %0, mcause": "=r"(mcause));

    //-- Si bit 31 es 1, es una interrupcion. 
    //-- Si bit 31 es 0, es una excepcion
    if (mcause & 0x80000000) {
        servicio_int();
    }
    else {
        //-- Es una excepcion
        //-- Enviar el codigo de excepcion
        servicio_excepcion(mcause);
    }

    //-- Aquí no llega nunca
    while(1);
}

void servicio_int() {
    //-- Encender los LEDs
    LEDS = 0xFFEF;

    //-- STOP!!
    while(1);
}

void servicio_excepcion(uint32_t mcause) 
{
    int btns;

    _puts("* Es una excepcion\n");

    //-- Mostrar causa excepcion en display
    disp_hex4(mcause);

    //-- Escribir un texto diciendo que tipo de excepcion es
    _puts(ANSI_BLUE);

    switch(mcause) {
        case 0: 
            _puts("--> FETCH MISALIGNED. Codigo 0\n");
            break;
    }

    //------ Animacion en los LEDs
    do {
        //-- Establecer valor 1 de la secuencia
        LEDS = VALOR1;

        //-- Pausa
        delay(PAUSA);

        //-- Valor 2 de la secuencia
        LEDS = VALOR2;

        //-- Pausa
        delay(PAUSA);

        //-- Leer pulsadores
        btns = read_buttons();

    } while ((btns & 0x1F) == 0);

    //-- Se ha apretado un pulsador
    //-- (pulsacion larga)

    //-- Punto de retorno: Funcion principal, para volver a empezar
    asm volatile("csrw mepc, %0": :"r"(main));

    //-- Salir de la interrupcion
    asm volatile("mret");

}


 
 