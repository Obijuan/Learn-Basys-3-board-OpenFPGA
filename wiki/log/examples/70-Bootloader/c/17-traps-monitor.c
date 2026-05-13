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
void servicio_int(uint32_t);
void servicio_excepcion(uint32_t); 
void trap_end();

//-- Configuracion secuencia en los LEDs
#define VALOR1 0xAAAA
#define VALOR2 0x5555
#define PAUSA _100ms


void opcion_timer();
void opcion_uart_tx();
void opcion_uart_rx();




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
    asm volatile("csrc mstatus, %0": : "r"(MSTATUS_MIE_MASK));

    //-- Deshabilitar las interrupciones de la UART
    UART_TX_STATUS = 0;
    UART_RX_STATUS = 0;

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
            //--------------------------------------------------
            //-- Generar la excepcion FETCH_FAULT. Codigo 1
            //--------------------------------------------------
            case '1':
                asm volatile (
                    "mv t0, zero \n\t"
                    "jalr t0 \n\t"
                );
                break;

            //--------------------------------------------------
            //-- Generar la excepcion ILEGAL_INSTRUCTION. Codigo 2
            //--------------------------------------------------
            case '2':
                asm volatile (".word 0");
                break;

            //--------------------------------------------------
            //-- Generar llamada EBREAK. Codigo 3
            //--------------------------------------------------
            case '3':
                asm volatile ("ebreak");
                break;
            //--------------------------------------------------
            //-- Generar la excepcion LOAD_MISALIGNED. Codigo 4
            //--------------------------------------------------
            case '4':
                asm volatile (
                    "la t0, 1f  \n\t"
                    "addi t0, t0, 1  \n\t"
                    "lw zero, 0(t0)  \n\t"
                    "1:              \n\t"
                );
                break;
            //--------------------------------------------------
            //-- Generar la excepcion LOAD FAULT. Codigo 5
            //--------------------------------------------------
            case '5':
                asm volatile ("lw zero, (zero)");
                break;
            //--------------------------------------------------
            //-- Generar la excepcion STORE MISALIGNED. Codigo 6
            //--------------------------------------------------
            case '6':
                asm volatile (
                    "la t0, 1f      \n\t"
                    "addi t0,t0,1   \n\t"
                    "sw zero, 0(t0) \n\t"
                    "1:             \n\t"
                );
                break;
            //--------------------------------------------------
            //-- Generar excepcion STORE FAULT. Codigo 7
            //--------------------------------------------------
            case '7':
                asm volatile ("sw zero, (zero)");
                break;
            //--------------------------------------------------
            //-- Generar llamada ECALL. Codigo 11
            //--------------------------------------------------
            case 'b':
                asm volatile ("ecall");
                break;
            //--------------------------------------------------
            //-- Generar Interrupcion del timer. Codigo ?
            //--------------------------------------------------
            case 'c':
                opcion_timer();
                break;
            //--------------------------------------------------
            //-- Generar interrupcion externa. Codigo ?
            //-- Caracter recibido por UART
            //--------------------------------------------------
            case 'd':
                opcion_uart_rx();
                break;
            //--------------------------------------------------
            //-- Generar interrupcion externa. Codigo ?
            //-- Buffer vacio. Listo para enviar
            //--------------------------------------------------
            case 'e':
                opcion_uart_tx();
                break;

        }

        //-- Ninguna opcion valida
        //-- Volver a pedir
    }

}

//------------------------------------------------
//-- Generar una interrupcion del temporizador
//------------------------------------------------
void opcion_timer()
{

    uint32_t timer_value;

    //-- Leer temporizador
    timer_value = TIMER_MTIME;

    //-- Añadir al comparador un tiempo de 1s
    TIMER_MTIMECMP = timer_value + 25000000;

    //-- Activar las interrupciones
    asm volatile ("csrs mie, %0": : "r"(MIE_MTIE_MASK));

    //-- Habilitar las interrupciones a nivel global
    asm volatile ("csrs mstatus, %0": : "r"(MSTATUS_MIE_MASK));

    //-- Bucle infinito: Mostrar temporizador en los LEDs
    //-- Hasta que salte la interrupcion
    for(;;) {
        timer_value = TIMER_MTIME;

        //-- Eliminar los 18 bits de menor peso
        //-- Solo se muestran los bits de 18 al 25
        LEDS = (timer_value >> 18);
    }
}

void opcion_uart_rx()
{

    _puts("\nPulsa una tecla...");

    //-- Habilitar interrupciones del receptor de la UART
    UART_RX_STATUS = UART_RX_STATUS_IE_MASK;

    //-- Habilitar las interrupciones externas
    asm volatile ("csrs mie, %0": : "r"(MIE_MEIE_MASK));

    //-- Habilitar las interrupciones a nivel global
    asm volatile ("csrs mstatus, %0": : "r"(MSTATUS_MIE_MASK));

    //-- Aqui no llega porque se produce la interrupcion
    for(;;);
}


void opcion_uart_tx()
{
    //-- Habilitar las interrupciones del transmisor de la UART
    UART_TX_STATUS = UART_TX_STATUS_IE_MASK;

    //-- Habilitar las interrupciones externas
    asm volatile ("csrs mie, %0": :"r"(MIE_MEIE_MASK));

    //-- Habilitar las interrupciones a nivel global
    asm volatile ("csrs mstatus, %0": : "r"(MSTATUS_MIE_MASK));

    //-- Transmitir un caracter para generar la interrupcion
    _putchar('A');

    //-- Aquí no llega
    for(;;);

}


//  #-- s1 -> Direccion de la UART
//     li s1, UART_ADDR

//     
//     li t0, UART_TX_STATUS_IE
//     sb t0, UART_TX_STATUS(s1)

//     #-- Habilitar las interrupciones externas
//     li t0, MIE_MEIE_MASK
//     csrs mie, t0

//     #-- Habilitar las interrupciones a nivel global
//     li t0, MSTATUS_MIE_MASK
//     csrs mstatus, t0

//     #-- Transmitir un caracter para generar la interrupcion
//     PUTCHARI 'A'



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
        servicio_int(mcause & ~0x80000000);
    }
    else {
        //-- Es una excepcion
        //-- Enviar el codigo de excepcion
        servicio_excepcion(mcause);
    }

    //-- Aquí no llega nunca
    while(1);
}


void servicio_excepcion(uint32_t mcause) 
{

    _puts("* Es una excepcion\n");

    //-- Mostrar causa excepcion en display
    disp_hex4(mcause);

    //-- Escribir un texto diciendo que tipo de excepcion es
    _puts(ANSI_BLUE);

    switch(mcause) {
        case 0: 
            _puts("--> FETCH MISALIGNED. Codigo 0\n");
            break;
        case 1:
            _puts("--> FETCH FAULTS. Codigo 1\n");
            break;
        case 2:
            _puts("--> ILEGAL INSTRUCTION. Codigo 2\n");
            break;
        case 3:
            _puts("--> EBREAK. Codigo 3\n");
            break;
        case 4:
            _puts("--> LOAD MISALIGNED. Codigo 4\n");
            break;
        case 5:
            _puts("--> LOAD FAULT. Codigo 5\n");
            break;
        case 6:
            _puts("--> STORE MISALIGNED. Codigo 6\n");
            break;
        case 7:
            _puts("--> STORE FAULS. Codigo 7\n");
            break;
        case 11:
            _puts("--> ECALL. Codigo 11\n");
            break;
    }

    //-- Terminar
    trap_end();
}

//----------------------------
//-- Finalizacion de la TRAP
//----------------------------
//-- Se muestra animacion en los LEDs
//-- Se espera a que usaurio apriete un pulsador
//-- Se comienza el programa de nuevo
//-------------------------------------------------
void trap_end()
{
    int btns;

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


void servicio_int(uint32_t mcause) {

    _puts("* Es una interrupcion\n");

    //-- Mostrar causa interrupcion en display
    disp_hex4(mcause);

    //-- Escribir un texto diciendo que tipo de interrupcion es
    _puts(ANSI_BLUE);

    switch(mcause) {

        //-----------------------------------
        //-- Interrupcion del temporizador
        //-----------------------------------
        case 7: 
            _puts("--> TIMER INT. Codigo 7\n");

            //-- Modificar temporizador para que no se
            //-- vuelva a producir la interrupcion al terminar
            TIMER_MTIMECMP = TIMER_MTIME + 25000000;

            //-- Deshabilitar interrupciones
            asm volatile("csrw mie, zero");
            break;

        //--------------------------------------------
        //-- Interrupcion externa
        //--------------------------------------------
        case 11:
            _puts("--> EXTERNAL INT\n");

            //-- La unica interrupcion externa es debido a la UART,
            //-- bien porque se ha recibido un carácter (RX)
            //-- o bien porque está lista para transmitir (TX)

            //-- Deshabilitar interrupciones
            asm volatile("csrw mie, zero");

            //-- Leer el dato recibido
            //-- Esto borra el flag de interrupcion
            //-- (por si hubiese sido el caso)
            //-- Leer la direccion base de la UART
            char volatile c = UART_BUFFER;
            break;

        //---------------------------------------
        //-- Otra interrupcion.. no conocida
        //-- NUNCA DEGERIA PASAR!!
        //---------------------------------------
        default:
            _puts("Interrupcion desconocida!");

    }

    //-- Fin
    trap_end();
}
 








//     halt
