

#ifndef _PERIPHERALS_H
#define _PERIPHERALS_H

#include <stdint.h>

//-- DIRECCIONES
#define MEMORY_ADDR            ((volatile uint16_t*)  0x00040000)
#define LEDS_ADDR              ((volatile uint16_t*)  0x00200000)
#define BUTTONS_ADDR           ((volatile uint8_t*)   0x00204000)
#define SWITCHES_ADDR          ((volatile uint16_t*)  0x00208000)
#define SEGMENTS_ADDR          ((volatile uint32_t*)  0x0020C000)
#define UART_BUFFER_ADDRESS    ((volatile uint8_t*)   0x00210000)
#define UART_RX_STATUS_ADDRESS ((volatile uint8_t*)   0x00210002)
#define UART_TX_STATUS_ADDRESS ((volatile uint8_t*)   0x00210003)
#define TIMER_STATUS_ADDR      ((volatile uint32_t*)  0x00214000) 
#define TIMER_MTIME_ADDR       ((volatile uint32_t*)  0x00214004)
#define TIMER_MTIMEH_ADDR      ((volatile uint32_t*)  0x00214008)
#define TIMER_MTIMECMP_ADDR    ((volatile uint32_t*)  0x0021400C)
#define TIMER_MTIMECMPH_ADDR   ((volatile uint32_t*)  0x00214010)
#define TEST_ADDRESS           ((volatile uint32_t *) 0x00480000)



//-- ACCESO A PERIFERICOS
#define MEMORY          *MEMORY_ADDR
#define LEDS            *LEDS_ADDR
#define BUTTONS         *BUTTONS_ADDR
#define SWITCHES        *SWITCHES_ADDR
#define SEGMENTS        *SEGMENTS_ADDR
#define TIMER_STATUS    *TIMER_STATUS_ADDR
#define TIMER_MTIME     *TIMER_MTIME_ADDR
#define TIMER_MTIMEH    *TIMER_MTIMEH_ADDR
#define TIMER_MTIMECMP  *TIMER_MTIMECMP_ADDR
#define TIMER_MTIMECMPH *TIMER_MTIMECMPH_ADDR
#define UART_BUFFER     *UART_BUFFER_ADDRESS
#define UART_RX_STATUS  *UART_RX_STATUS_ADDRESS
#define UART_TX_STATUS  *UART_TX_STATUS_ADDRESS

//───── LEDS
//── Máscaras de acceso individual a los LEDs
#define LED0 1
#define LED1 1 << 1
#define LED2 1 << 2
#define LED3 1 << 3
#define LED4 1 << 4
#define LED5 1 << 5
#define LED6 1 << 6
#define LED7 1 << 7
#define LED8 1 << 8
#define LED9 1 << 9
#define LED10 1 << 10
#define LED11 1 << 11
#define LED12 1 << 12
#define LED13 1 << 13
#define LED14 1 << 14
#define LED15 1 << 15

//───── PULSADORES
//── Máscaras de acceso individual a los pulsadores
#define BTN_CENTER 1       //-- Bit 0
#define BTN_UP     1 << 1  //-- Bit 1
#define BTN_LEFT   1 << 2  //-- Bit 2
#define BTN_RIGHT  1 << 3  //-- Bit 3
#define BTN_DOWN   1 << 4  //-- Bit 4




//-- Indices de acceso a los bits de la UART
#define UART_RX_STATUS_IDX_ER     0
#define UART_RX_STATUS_IDX_IE     1
#define UART_RX_STATUS_IDX_FULL   2
#define UART_TX_STATUS_IDX_ER     0
#define UART_TX_STATUS_IDX_IE     1
#define UART_TX_STATUS_IDX_EMPTY  2

//-- Mascaras
#define UART_TX_STATUS_EMPTY_MASK  (1 << UART_TX_STATUS_IDX_EMPTY)
#define UART_TX_STATUS_IE_MASK     (1 << UART_TX_STATUS_IDX_IE)
#define UART_RX_STATUS_FULL_MASK   (1 << UART_RX_STATUS_IDX_FULL)
#define UART_RX_STATUS_ER_MASK     (1 << UART_TX_STATUS_IDX_ER)
#define UART_RX_STATUS_IE_MASK     (1 << UART_RX_STATUS_IDX_IE)


#define VGA_START_ADDRESS             (((volatile uint32_t *) ((0x00090000    ) << 2)))
#define VGA_START_BYTE_ADDRESS        (((volatile uint8_t  *) ((0x00090000    ) << 2)))
#define VGA_START_HALFWORD_ADDRESS    (((volatile uint16_t *) ((0x00090000    ) << 2)))
#define VGA_START_WORD_ADDRESS        (((volatile uint32_t *) ((0x00090000    ) << 2)))



#endif //_PERIPHERALS_
