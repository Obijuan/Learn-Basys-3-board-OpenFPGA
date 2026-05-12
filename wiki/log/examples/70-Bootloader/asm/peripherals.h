
#─────────  Direcciones de los perifericos
.equ MEMORY_ADDR,      0x00040000
.equ LEDS_ADDR,        0x00200000
.equ BUTTONS_ADDR,     0x00204000
.equ SWITCHES_ADDR,    0x00208000
.equ SEGMENTS_ADDR,    0x0020C000
.equ UART_ADDR,        0x00210000
.equ TIMER_ADDR,       0x00214000


#───── LEDS
#── Máscaras de acceso individual a los LEDs
.equ LED0, 1
.equ LED1, 1 << 1
.equ LED2, 1 << 2
.equ LED3, 1 << 3
.equ LED4, 1 << 4
.equ LED5, 1 << 5
.equ LED6, 1 << 6
.equ LED7, 1 << 7
.equ LED8, 1 << 8
.equ LED9, 1 << 9
.equ LED10, 1 << 10
.equ LED11, 1 << 11
.equ LED12, 1 << 12
.equ LED13, 1 << 13
.equ LED14, 1 << 14
.equ LED15, 1 << 15

#───── PULSADORES
#── Máscaras de acceso individual a los pulsadores
.equ BTN_CENTER, 1      #-- Bit 0
.equ BTN_UP,    1 << 1  #-- Bit 1
.equ BTN_LEFT,  1 << 2  #-- Bit 2
.equ BTN_RIGHT, 1 << 3  #-- Bit 3
.equ BTN_DOWN,  1 << 4  #-- Bit 4

#───── SWITCHES
#── Máscaras de acceso individual
.equ SW0, 1
.equ SW1, 1 << 1
.equ SW2, 1 << 2
.equ SW3, 1 << 3
.equ SW4, 1 << 4
.equ SW5, 1 << 5
.equ SW6, 1 << 6
.equ SW7, 1 << 7
.equ SW8, 1 << 8
.equ SW9, 1 << 9
.equ SW10, 1 << 10
.equ SW11, 1 << 11
.equ SW12, 1 << 12
.equ SW13, 1 << 13
.equ SW14, 1 << 14
.equ SW15, 1 << 15

#────────────── UART
#── Registros de la UART
#-- Offset de los registros de la UART
.equ UART_DATA, 0x0
.equ UART_RX_STATUS, 0x2
.equ UART_TX_STATUS, 0x3

#── Máscaras de acceso a los bits
.equ UART_RX_STATUS_ER,     1 << 0
.equ UART_RX_STATUS_IE,     1 << 1
.equ UART_RX_STATUS_FULL,   1 << 2
.equ UART_TX_STATUS_ER,     1 << 0
.equ UART_TX_STATUS_IE,     1 << 1
.equ UART_TX_STATUS_EMPTY,  1 << 2


#─────────── TIMER
#──── Offsets del timer
.equ MTIME_STATUS, 0x00
.equ MTIME,        0x04
.equ MTIMEH,       0x08
.equ MTIMECMP,     0x0C
.equ MTIMECMPH,    0x10

