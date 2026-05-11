
#─────────  Direcciones de los perifericos
.equ MEMORY_ADDR,      0x00040000
.equ LEDS_ADDR,        0x00200000
.equ BUTTONS_ADDR,     0x00204000
.equ SEGMENTS_ADDR,    0x0020C000

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

#── Máscaras de acceso individual a los pulsadores
.equ BTN_CENTER, 1      #-- Bit 0
.equ BTN_UP,    1 << 1  #-- Bit 1
.equ BTN_LEFT,  1 << 2  #-- Bit 2
.equ BTN_RIGHT, 1 << 3  #-- Bit 3
.equ BTN_DOWN,  1 << 4  #-- Bit 4
