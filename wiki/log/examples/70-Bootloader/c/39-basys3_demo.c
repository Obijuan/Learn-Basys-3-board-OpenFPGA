/* Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
 * Embedded Architectures & Systems Group, Graz University of Technology
 * SPDX-License-Identifier: MIT
 * ---------------------------------------------------------------------
 * File: basys3_demo.c
 */
#include "buttons.h"
#include "delay.h"
#include "uart.h"


// ------------------------------------------------------------------------------------------------
// |                                                                                              |
// | Test program for HaDes-V on Basys3.                                                          |
// |                                                                                              |
// | 14 different tests are executed in the main function of this file.                           |
// | Pressing the east button triggers the main to jump to the next test case.                    |
// |                                                                                              |
// | "glob_value" is used for visualization or to trigger something                               |
// |     USE_TIMER_INTERRUPT_TO_INCREMENT_GLOB_VALUE defined => incremented on timer-interrupt    |
// |     USE_TIMER_INTERRUPT_TO_INCREMENT_GLOB_VALUE not defined => increment after n cpu cycles  |
// |                                                                                              |
// | Tests:                                                                                       |
// |     0 TEST_LEDS: binary representation of "glob_value"                                       |
// |     1 TEST_LEDS_WALK: sequential lighting of the LEDs                                        |
// |     2 TEST_BUTTONS: set the corresponding led depending on the button state                  |
// |     3 TEST_SWITCHES: set the corresponding led depending on the switch state                 |
// |     4 TEST_7_SEGMENTS: representation of "glob_value" on the 7 segments                      |
// |     5 TEST_UART_SEND: send the transmit message over UART by polling the UART state          |
// |     6 TEST_UART_ECHO: echo the received UART byte by polling the UART state                  |
// |     7 TEST_UART_SEND_INTERRUPT: send the transmit message over UART using interrupts         |
// |     8 TEST_UART_ECHO_INTERRUPT: echo the received UART byte using interrupts                 |
// |     9 TEST_VGA_PX_IDX: draw lines in different colors to VGA screen (store byte     - 1px)   |
// |    10 TEST_VGA_BYTE_IDX: ---------------------"-------------------- (store byte     - 2px)   |
// |    11 TEST_VGA_HALFWORD_IDX: -----------------"-------------------- (store halfword - 4px)   |
// |    12 TEST_VGA_WORD_IDX: ---------------------"-------------------- (store word     - 8px)   |
// |    13 TEST_VGA_MIXED_IDX: --------------------"-------------------- (SB, SB, SH, SW)         |
// |                                                                                              |
// ------------------------------------------------------------------------------------------------

#include <stdlib.h>
#include <stdint.h>

#include "peripherals.h"
#include "helperfunctions.h"

// uncomment the following line to simply increment "glob_value" after some cpu cycles
#define USE_TIMER_INTERRUPT_TO_INCREMENT_GLOB_VALUE

uint32_t    glob_value = 0;
const char* uart_transmit_message = "Transmitting char by char using interrupts seems to work!\n";

enum Test {
    TEST_LEDS,
    TEST_LEDS_WALK,
    TEST_BUTTONS,
    TEST_SWITCHES,
    TEST_7_SEGMENTS,
    TEST_UART_SEND,
    TEST_UART_ECHO,
    TEST_UART_SEND_INTERRUPT,
    TEST_UART_ECHO_INTERRUPT,
    TEST_VGA_PX_IDX,
    TEST_VGA_BYTE_IDX,
    TEST_VGA_HALFWORD_IDX,
    TEST_VGA_WORD_IDX,
    TEST_VGA_MIXED_IDX,
    TEST_DUMMY_FINAL // only for recognizing last test
};

// --------------------------------------------------------------
// |                  Helpers                                   |
// --------------------------------------------------------------

//-- Incrementar el contador global
void incrementGlobValue() {
    glob_value++;

    //-- Es un contador de 16-bits (porque es lo que se muestra
    //-- en los leds). Cuando se activa el bit 16, se vuelve a 0
    if (glob_value >> 16) {
        glob_value = 0;
    }
}


int str_length(const char* str_to_check) {
    int count;
    for (count = 0; str_to_check[count] != '\0'; ++count);
    return count;
}

void waitSomeCycles() {
    uint32_t wait_loop_cnt = (1<<24);
    while(wait_loop_cnt > 0) {
        wait_loop_cnt--;
    }
}

//-- Mostrar el estado de la UART en los LEDs
void signalUartErrorOnLeds(uint8_t tx_status, uint8_t rx_status) {

    uint16_t err_leds_data = 0;

    //-- Mostrar en la parte alta de los LEDs el registro
    //-- de estado de transmisión, si hay error
    //-- El nibble superior del registro de estatus se muestra como 0xF
    if (tx_status & UART_TX_STATUS_ER_MASK) { 
        err_leds_data = err_leds_data | (0xF0 | tx_status)<<8; 
    }

    //-- Mostrar el registro de estatus del receptor en la parte baja
    //-- de los LEDs, si hay error
    if (rx_status & UART_RX_STATUS_ER_MASK) {
        err_leds_data = err_leds_data | (0xF0 | rx_status); 
    }

    //-- Si hay error, mostrar el estado correspondiente en los LEDs
    if (err_leds_data != 0) {
        LEDS = err_leds_data;

        //-- Esperar
        delay(_1s);
    }
}

// --------------------------------------------------------------------
// |                   Interrupt                                      |
// --------------------------------------------------------------------

//-- Interrupcion del temporizador
void handleTimerInterrupt() {

    //-- Incrementar contador global
    incrementGlobValue();

    //--Resetear el contador
    TIMER_MTIME  = 0;
    TIMER_MTIMEH = 0;
}


void handleExternalInterrupt() {
    static uint8_t  tx_char_idx = 0;
    // check uart transmit interrupt
    uint8_t uart_tx_status = *UART_TX_STATUS_ADDRESS;
    uint8_t uart_tx_status_mask = (1<<UART_TX_STATUS_IDX_IE) | (1<<UART_TX_STATUS_IDX_EMPTY);
    if ((uart_tx_status & uart_tx_status_mask) == uart_tx_status_mask) {
        // transmit next char
        if (tx_char_idx < str_length(uart_transmit_message)) {
            *UART_BUFFER_ADDRESS = uart_transmit_message[tx_char_idx];
            tx_char_idx++;
        } else {
            enableDisable_uartInterrupts(0, 0); // (enabled again after some time)
            tx_char_idx = 0;
        }
    }
    // check uart receive interrupt
    uint8_t uart_rx_status = *UART_RX_STATUS_ADDRESS;
    uint8_t uart_rx_status_mask = (1<<UART_RX_STATUS_IDX_IE) | (1<<UART_RX_STATUS_IDX_FULL);
    if ((uart_rx_status & uart_rx_status_mask) == uart_rx_status_mask) {
        // get received data
        uint8_t uart_rx_data = *UART_BUFFER_ADDRESS;
        // echo received data and reset errors
        *UART_BUFFER_ADDRESS = (uint32_t)uart_rx_data;
    }
    // check rx/tx error on leds
    signalUartErrorOnLeds(uart_tx_status, uart_rx_status);
}

__attribute__((interrupt))
void interrupt() 
{
    uint16_t err_leds_data = 0;
    uint32_t mcause = 0;

    //-- Leer la causa de interrupcion
    asm volatile("csrr %0, mcause": "=r"(mcause));

    //-- Si es una excepcion, sacar 0x7FFF por los LEDs!
    switch (mcause) {

        //-- EXCEPCIONES!
        case 0:  // FETCH_MISALIGNED 
        case 1:  // FETCH_FAULT
        case 2:  // ILLEGAL_INSTRUCTION
        case 3:  // EBREAK
        case 4:  // LOAD_MISALIGNED
        case 5:  // LOAD_FAULT
        case 6:  // STORE_MISALIGNED
        case 7:  // STORE_FAULT
        case 11: // ECALL
            err_leds_data = 0x7FFF; 
            break; 

        //-- INTERRUPCIONES!!
        case ((1<<31) |  7):    // TIMER INTERRUPT
            handleTimerInterrupt(); 
            break; 
        case ((1<<31) | 11):    // EXTERNAL INTERRUPT
            handleExternalInterrupt(); 
            break; 

        //-- UNKNOWN EXCEPTION/INTERRUPT!
        default: 
            err_leds_data = 0x7FFF; 
            break;
    }

    //-- Si ocurre una excepcion, realizar una pausa
    if (err_leds_data) {

        //-- Poner el tipo (exc/int) en el LED15
        LEDS = err_leds_data | ((mcause>>31 & 0b1)<<15);

        //-- Sacar por el 7 segmentos la causa de interrupcion
        SEGMENTS = number2segment(mcause & (~(1<<31)) );

        //-- pausa
        delay(_1s);
    }

    //-- En caso de excepción, vuelve a saltar aquí otra vez
    //-- (Porque el registro mepc contiene la dirección de la instrucción
    //--  que ha generado la excepcion)
}


// --------------------------------------------------------------
// |                 LEDs                                       |
// --------------------------------------------------------------

//-- Prueba de LEDs: Mostrar un contador incrementando
//-- mediante interrupciones
void test_leds() 
{
    *LEDS_ADDR = glob_value;
}


//-- Secuencia en los LEDs
void test_leds_walk() 
{
    static uint32_t last_glob_val = 0;

    //-- Comprobar si hay cambio en el contador global
    if (last_glob_val != glob_value) {

        //-- Cambio. Actualizar valor actual
        last_glob_val = glob_value;

        //-- Desplazar a la izquierda el valor en los LEDs
        LEDS = (LEDS << 1);

        //-- Restaurar el valor cuando sale por la izquierda
        if (LEDS == 0)
            LEDS = 1;
    }
}

// -----------------------------------------------------------
// |               BUTTONS                                   |
// -----------------------------------------------------------

//-- Mostrar los botones en los LEDs
void test_buttons() 
{
    uint8_t buttons;

    //-- Leer pulsadores
    buttons = BUTTONS;

    //-- Mostrarlos en los LEDs
    LEDS = (uint16_t)buttons;
}


// ------------------------------------------------------------------------------------------------
// |                                           SWITCHES                                           |
// ------------------------------------------------------------------------------------------------
void test_switches() {
    uint16_t switches;
    switches = *SWITCHES_ADDR;
    *LEDS_ADDR = switches;
}

// ------------------------------------------------------------------------------------------------
// |                                          7-Segments                                          |
// ------------------------------------------------------------------------------------------------
void test_7segments() {
    static uint32_t last_glob_val = 0;
    if (last_glob_val != glob_value) {
        last_glob_val = glob_value;
        uint32_t segment_dec = number2segment(glob_value);
        *SEGMENTS_ADDR = segment_dec;
    }
}

// ------------------------------------------------------------------------------------------------
// |                                             UART                                             |
// ------------------------------------------------------------------------------------------------
void test_uart_send() {
    static uint32_t last_glob_val = 0;
    static uint8_t  trigger_send = 0;
    if (last_glob_val != glob_value) {
        last_glob_val = glob_value;
        trigger_send  = 1;
    }
    // read the status
    uint8_t uart_rx_status = *UART_RX_STATUS_ADDRESS;
    uint8_t uart_tx_status = *UART_TX_STATUS_ADDRESS;
    // signal rx/tx error on leds
    signalUartErrorOnLeds(uart_tx_status, uart_rx_status);
    // send global value if buffer empty and last != current
    if (trigger_send && (uart_tx_status & (1<<UART_TX_STATUS_IDX_EMPTY))) {
        trigger_send = 0;
        // send global value
        *UART_BUFFER_ADDRESS = (uint8_t)(glob_value & 0xFF);
    }
}

void test_uart_echo() {
    // read the status
    uint8_t uart_rx_status = *UART_RX_STATUS_ADDRESS;
    uint8_t uart_tx_status = *UART_TX_STATUS_ADDRESS;
    // signal rx/tx error on leds
    signalUartErrorOnLeds(uart_tx_status, uart_rx_status);
    // echo received byte
    if (uart_rx_status & (1<<UART_RX_STATUS_IDX_FULL)) {
        // read out received byte
        uint8_t received_byte = *UART_BUFFER_ADDRESS;
        // send received byte back
        *UART_BUFFER_ADDRESS = received_byte;
    }
}

void test_uart_send_interrupt() {
    static uint32_t last_glob_val = 0;
    // enable interrupts after some time
    if (last_glob_val != glob_value) {
        last_glob_val = glob_value;
        enableDisable_uartInterrupts(0, 1);
    }
    // nothing else done here (see interrupt handler)
}

void test_uart_echo_interrupt() {
    // nothing done here (see interrupt handler)
}

// ------------------------------------------------------------------------------------------------
// |                                             VGA                                              |
// ------------------------------------------------------------------------------------------------
void test_vga(uint8_t pixel_cnt) {
    static uint32_t last_glob_val = 0;
    static uint8_t  do_something = 0;
    static uint8_t  prev_pixel_cnt = 0;
    static uint32_t px_idx = 0;
    static uint8_t  clear_fill_screen = 1;
    static vga_color_t px_color = VGA_COLOR_BLACK;
    // trigger new fill/clear screen
    if ((last_glob_val+3) <= glob_value) {
        last_glob_val = glob_value;
        do_something  = 1;
    }
    // check if pixel indexing changed
    if (pixel_cnt != prev_pixel_cnt) {
        prev_pixel_cnt = pixel_cnt;
        px_idx = 0;
        px_color = VGA_COLOR_BLACK;
        clear_fill_screen = 1;
    }
    if (do_something) {
        // fill or clear screen
        if (clear_fill_screen) {
            // switch to next color
            px_color = px_color + 1;
            if (px_color >= 16) { px_color = 0; }
        } else {
            px_color = VGA_COLOR_BLACK;
        }
        // set pixel
        if      (pixel_cnt == 1) { setPixel(px_idx, px_color);         px_idx += 1; }
        else if (pixel_cnt == 2) { setPixelByte(px_idx, px_color);     px_idx += 2; }
        else if (pixel_cnt == 4) { setPixelHalfword(px_idx, px_color); px_idx += 4; }
        else if (pixel_cnt == 8) { setPixelWord(px_idx, px_color);     px_idx += 8; }
        // check index boundary
        if (px_idx >= VGA_SCREEN_WIDTH*VGA_SCREEN_HEIGHT) {
            px_idx = 0;
            clear_fill_screen = !clear_fill_screen;
            do_something = 0;
        }
    }
}

void test_vga_mixed_idx() {
    static uint32_t    px_idx = 0;
    static vga_color_t px_color = VGA_COLOR_BLACK;
    // switch to next color
    px_color = px_color + 1;
    if (px_color >= 16) { px_color = 0; }
    // set pixel
    if      (px_idx < (VGA_SCREEN_WIDTH*VGA_SCREEN_HEIGHT) * 1/4) { setPixel(px_idx, px_color);         px_idx += 1; }
    else if (px_idx < (VGA_SCREEN_WIDTH*VGA_SCREEN_HEIGHT) * 2/4) { setPixelByte(px_idx, px_color);     px_idx += 2; }
    else if (px_idx < (VGA_SCREEN_WIDTH*VGA_SCREEN_HEIGHT) * 3/4) { setPixelHalfword(px_idx, px_color); px_idx += 4; }
    else if (px_idx < (VGA_SCREEN_WIDTH*VGA_SCREEN_HEIGHT) * 4/4) { setPixelWord(px_idx, px_color);     px_idx += 8; }
    else                                                          { px_color = VGA_COLOR_BLACK;         px_idx  = 0; }
}

// ----------------------------------------------------------
// |                      MAIN                              |
// ----------------------------------------------------------
void main() {

    //-- Numero de test
    static uint32_t test_nr = TEST_LEDS;

    //-- Estado de los pulsadores
    int buttons;

    //-- Inicializar modulo de los pulsadores
    buttons_init();

    //-- Set interrupt/exception handler
    asm("csrw mtvec, %0": : "r"(interrupt));

    //-- Comprobar si hay algun error en la UART
    signalUartErrorOnLeds(UART_TX_STATUS, UART_RX_STATUS);

    //-- Interrupcion del temporizador y externas deshabilitadas
    //-- por defecto
    enableDisable_externalInterrupts(0);
    enableDisable_timerInterrupts(0);

    //-- Activar las interrupciones globales
    enableDisable_machineInterrupts(1);


    //------- Establecer las interrupciones del temporizador
    //-------  cada 0.5 segundos
    //-- Leer duracion de cada ciclo de temporizador
    //-- (Para 25Mhz es de 40)
    uint32_t ns_per_cycle = TIMER_STATUS & 0xFF;

    //-- Calcular los ciclos que deben transcurrir para llegar 
    //-- a 0.5 segundos
    uint32_t cycles_per_second = 500000000 / ns_per_cycle;

    //-- Configurar temporizador para producir una interrupcion
    //-- transcurrido ese tiempo
    TIMER_MTIMECMP  = cycles_per_second;
    TIMER_MTIMECMPH = 0;

    //-- Habilitar interrupcion del temporizador!!!!
    enableDisable_timerInterrupts(1);

    
    //-- Bucle principal!!
    while (1) {

        //-- Leer los pulsadores
        uint8_t buttons = read_buttons();

        //-- Se ha pulsado el botón derecho
        //-- Pasar al siguiente TEST
        if (buttons & BTN_RIGHT) {

            //-- Seleccionar el siguiente TEST
            test_nr++;

            //-- Si estamos en el ultimo TEST, volver
            //-- al comienzo
            if (test_nr >= TEST_DUMMY_FINAL)  
                test_nr = 0; 

            //----- Configuraciones generales para todos
            //-- los tests
            //  Deshabilitar las interrupciones
            enableDisable_machineInterrupts(0);
            enableDisable_externalInterrupts(0);
            enableDisable_uartInterrupts(0, 0);

            //-- Apagar los LEDs
            LEDS     = 0;

            //-- Apagar los displays de 7 segmentos
            SEGMENTS = 0;

            //-- A partir de los tests de los 7 segmentos en 
            //-- adelante, mostrar el numero de test en los displays
            if (test_nr > TEST_7_SEGMENTS) 
                SEGMENTS = number2segment(test_nr);
            
            //-- Configuraciones especificas segun el TEST actual
            switch (test_nr) {
                case TEST_LEDS: 
                    LEDS = 0;  
                    break;

                case TEST_LEDS_WALK: 
                    LEDS = 1;  //-- Valor inicial secuencia
                    break;

                case TEST_BUTTONS: 
                    break;

                case TEST_SWITCHES: 
                    break;

                case TEST_7_SEGMENTS          : *SEGMENTS_ADDR = 0; break;
                case TEST_UART_SEND           : break;
                case TEST_UART_ECHO           : break;
                case TEST_UART_SEND_INTERRUPT :
                    //enableDisable_externalInterrupts(1);
                    //enableDisable_uartInterrupts(0, 1);
                    break;
                case TEST_UART_ECHO_INTERRUPT :
                    //enableDisable_externalInterrupts(1);
                    //enableDisable_uartInterrupts(1, 0);
                    break;
                case TEST_VGA_PX_IDX          : break;
                case TEST_VGA_BYTE_IDX        : break;
                case TEST_VGA_HALFWORD_IDX    : break;
                case TEST_VGA_WORD_IDX        : break;
                case TEST_VGA_MIXED_IDX       : break;
                default :
                    test_nr = 0;
                    break;
            }
            enableDisable_machineInterrupts(1);
        }
        
        
        //-- Acción a realizar en el test actual
        switch (test_nr) {

            case TEST_LEDS:   //-- Contador en los LEDs 
                test_leds();  //-- Mediante interrupciones
                break;

            case TEST_LEDS_WALK:  //-- Secuencia en LEDs
                test_leds_walk(); 
                break;

            case TEST_BUTTONS:  //-- Mostrar botones en LEDs 
                test_buttons(); 
                break;

            case TEST_SWITCHES            : test_switches(); break;
            case TEST_7_SEGMENTS          : test_7segments(); break;
            case TEST_UART_SEND           : test_uart_send(); break;
            case TEST_UART_ECHO           : test_uart_echo(); break;
            case TEST_UART_SEND_INTERRUPT: 
                //test_uart_send_interrupt(); 
                break;
            case TEST_UART_ECHO_INTERRUPT: 
                //test_uart_echo_interrupt(); 
                break;
            case TEST_VGA_PX_IDX: 
                //test_vga(1); 
                break;
            case TEST_VGA_BYTE_IDX: 
                //test_vga(2); 
                break;
            case TEST_VGA_HALFWORD_IDX:
                //test_vga(4); 
                break;
            case TEST_VGA_WORD_IDX: 
                //test_vga(8); break;
                break;
            case TEST_VGA_MIXED_IDX: 
                //test_vga_mixed_idx(); 
                break;
            default :
                test_nr = 0;
                break;
        }
    }
    
}

    //-- DEBUG
    //LEDS = 0x000F;
    //while(1);

