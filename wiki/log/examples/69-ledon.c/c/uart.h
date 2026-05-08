#ifndef _UART_H
#define _UART_H

//-- Prototipos
void __transmit_char(char c);
void __transmit_string(char *val);
int __receive_byte();
char __receive_hex_char();
int __receive_hex_byte();


#endif //_UART_H
