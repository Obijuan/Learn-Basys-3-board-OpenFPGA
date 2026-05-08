//-- Acceso a los tipos estandares: uint8_t, uint16_t...
#include <stdint.h>

//-- Acceso a perifericos
#include <peripherals.h>

//-- Otras bibliotecas
#include <uart.h>

void __copy_bootloader();

extern char __boot_start;
extern char __boot_end;
extern char __boot_load;


__attribute__((naked))
void __reset() {
    
    //-- Inicializar la pila
    asm("la sp, __ram_end");
    asm("j __copy_bootloader");
}


void __copy_bootloader() {

    LEDS = 0x0001;
    while(1);

    //-- El bootloader está situado al comienzo de la memoria
    //-- Lo primero que se hace es copiarlo a otra zona
    char *source = &__boot_load;
    char *dest = &__boot_start;

    while (dest < &__boot_end) {
        *dest = *source;
        dest++;
        source++;
    }

    while (1) {
        LEDS = 0x0003;
    //    __bootloader();
    }
}

//-- Dependencias
#include <uart.c>

